//
//    Copyright (C) Microsoft.  All rights reserved.
// Licensed under the terms described in the LICENSE file in the root of this project.
//

#include "stdafx.h"

// #define STANDALONE

// Commandline arguments:
constexpr auto ARG_CONFIG = L"config";
constexpr auto ARG_CONFIG_DEFAULT_USER = L"--default-user";
constexpr auto ARG_INSTALL = L"install";
constexpr auto ARG_INSTALL_ROOT = L"--root";
constexpr auto ARG_RUN = L"run";
constexpr auto ARG_RUN_C = L"-c";
// ReSharper disable once IdentifierTypo
// ReSharper disable once StringLiteralTypo
constexpr auto ARG_SYSTEMD = L"--systemd";
// ReSharper disable once IdentifierTypo
constexpr auto ARG_SYSTEMD_D = L"-s";

#include <winrt/Windows.Foundation.h> //do not remove
#include <winrt/Windows.System.h>
#include <winrt/Windows.Storage.h>


using namespace winrt;
using namespace Windows::UI::ViewManagement;
using namespace Windows::Foundation;
using namespace Windows::System;
using namespace Windows::Storage;


// Helper class for calling WSL Functions:
// https://msdn.microsoft.com/en-us/library/windows/desktop/mt826874(v=vs.85).aspx
WslApiLoader g_wslApi(DistributionInfo::Name);

static HRESULT InstallDistribution(bool createUser);
static HRESULT SetDefaultUser(std::wstring_view userName);

HRESULT InstallDistribution(bool createUser)
{
    // Register the distribution.
    Helpers::SendStartProcessSignal();
    Helpers::PrintMessage(MSG_STATUS_INSTALLING);
    auto hr = g_wslApi.WslRegisterDistribution();
    if (FAILED(hr))
    {
        return hr;
    }

    // Delete /etc/resolv.conf to allow WSL to generate a version based on Windows networking information.
    DWORD exitCode;
    hr = g_wslApi.WslLaunchInteractive(L"/bin/rm /etc/resolv.conf", true, &exitCode);
    if (FAILED(hr))
    {
        return hr;
    }

    Helpers::SendStopProcessSignal();

    // Create a user account.
    if (createUser)
    {
        Helpers::PrintMessage(MSG_CREATE_USER_PROMPT);
        std::wstring userName;
        do
        {
            userName = Helpers::GetUserInput(MSG_ENTER_USERNAME, 32);
        }
        while (!DistributionInfo::CreateUser(userName));

        // Set this user account as the default.
        hr = SetDefaultUser(userName);
        if (FAILED(hr))
        {
            return hr;
        }
    }

    return hr;
}

HRESULT SetDefaultUser(std::wstring_view userName)
{
    // Query the UID of the given user name and configure the distribution
    // to use this UID as the default.
    const auto uid = DistributionInfo::QueryUid(userName);
    if (uid == UID_INVALID)
    {
        return E_INVALIDARG;
    }

    const auto hr = g_wslApi.WslConfigureDistribution(uid, WSL_DISTRIBUTION_FLAGS_DEFAULT);
    if (FAILED(hr))
    {
        return hr;
    }

    DistributionInfo::ChangeDefaultUserInWslConf(userName);

    return hr;
}

int RetrieveCurrentTheme()
{
    DWORD value = 0;
    DWORD size = sizeof value;

    // ReSharper disable once CppTooWideScope
    const auto status = RegGetValueW(HKEY_CURRENT_USER,
                                     L"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize",
                                     L"AppsUseLightTheme",
                                     RRF_RT_DWORD,
                                     nullptr,
                                     &value,
                                     &size
    );

    if (status == ERROR_SUCCESS)
    {
        return value;
    }

    return -1;
}

fire_and_forget SyncIcons()
{
    const int value = RetrieveCurrentTheme();
    const hstring nameSuffix = value == 0 ? L".theme-dark" : L"";
    const hstring iconName = L"fedoraremix";

    const hstring extension = L".png";
    const hstring composedPath = iconName + nameSuffix + extension;
    const auto path = Uri(L"ms-appx:///Assets/" + composedPath);

    try
    {
        const auto iconFile = StorageFile::GetFileFromApplicationUriAsync(path).get();

        co_await iconFile.CopyAsync(ApplicationData::Current().LocalFolder(), iconName + extension,
                                    NameCollisionOption::ReplaceExisting);
    }
    catch (...)
    {
    }
}

fire_and_forget SyncBackground()
{
    const int value = RetrieveCurrentTheme();
    const hstring nameSuffix = L"";
    const hstring backgroundName = L"Fedora_remix_purple_darkbackground_370";

    const hstring extension = L".png";
    const hstring composedPath = backgroundName + nameSuffix + extension;
    const auto path = Uri(L"ms-appx:///Assets/" + composedPath);

    try
    {
        const auto iconFile = StorageFile::GetFileFromApplicationUriAsync(path).get();

        co_await iconFile.CopyAsync(ApplicationData::Current().LocalFolder(), backgroundName + extension,
                                    NameCollisionOption::FailIfExists);
    }
    catch (...)
    {
    }
}

fire_and_forget ShowFedoraRemixUi()
{
    // ReSharper disable once CppTooWideScope
    const auto file =
        co_await ApplicationData::Current().LocalFolder().TryGetItemAsync(L"MicrosoftStoreEngagementSDKId.txt");

    if (!file)
    {
        // ReSharper disable once StringLiteralTypo
        const hstring str = L"fedoraremixwslui://";

        const auto uri = Uri(str);

        co_await Launcher::LaunchUriAsync(uri);
    }
}

bool IsCurrentDirNotSystem32()
{
    wchar_t system32Dir[MAX_PATH];
    GetSystemDirectoryW(system32Dir, MAX_PATH);

    wchar_t currentDir[MAX_PATH];
    GetCurrentDirectoryW(MAX_PATH, currentDir);

    return _wcsicmp(system32Dir, currentDir) != 0;
}

void CheckIfAResetWasMade()
{
    if (!g_wslApi.WslIsDistributionRegistered())
    {
        return;
    }

    const auto localStateFolder = ApplicationData::Current().LocalFolder();
    // ReSharper disable once CppTooWideScopeInitStatement
    const auto files = localStateFolder.GetFilesAsync().get();

    if (files.Size() != 0)
    {
        return;
    }

    // ReSharper disable once CppExpressionWithoutSideEffects
    g_wslApi.WslUnregisterDistribution();
}

int wmain(int argc, const wchar_t* argv[])
{
    // Update the title bar of the console window.
    SetConsoleTitleW(DistributionInfo::WindowTitle.c_str());

    // Initialize a vector of arguments.
    std::vector<std::wstring_view> arguments;
    for (auto index = 1; index < argc; index += 1)
    {
        arguments.push_back(argv[index]);
    }

    // Ensure that the Windows Subsystem for Linux optional component is installed.
    DWORD exitCode = 1;
    if (!g_wslApi.WslIsOptionalComponentInstalled())
    {
        Helpers::PrintMessage(MSG_MISSING_OPTIONAL_COMPONENT);
        if (arguments.empty())
        {
            Helpers::PromptForInput();
        }

        return static_cast<int>(exitCode);
    }

    //CheckIfAResetWasMade();

    // Install the distribution if it is not already.
    const auto installOnly = arguments.size() > 0 && arguments[0] == ARG_INSTALL;
    auto hr = S_OK;
    if (!g_wslApi.WslIsDistributionRegistered())
    {
        // If the "--root" option is specified, do not create a user account.
        const auto useRoot = installOnly && arguments.size() > 1 && arguments[1] == ARG_INSTALL_ROOT;
        hr = InstallDistribution(!useRoot);
        if (FAILED(hr))
        {
            if (hr == HRESULT_FROM_WIN32(ERROR_ALREADY_EXISTS))
            {
                Helpers::PrintMessage(MSG_INSTALL_ALREADY_EXISTS);
            }
        }
        else
        {
            Helpers::PrintMessage(MSG_INSTALL_SUCCESS);
        }

        exitCode = SUCCEEDED(hr) ? 0 : 1;
    }

    // Parse the command line arguments.
    if (SUCCEEDED(hr) && !installOnly)
    {
        SyncIcons();
        SyncBackground();

#ifndef STANDALONE
        ShowFedoraRemixUi();
#endif

        if (arguments.empty())
        {
            /* If the current working dir is not System32 then it was called from Open with Terminal
            option or from command line. In this case is better to start the distro in the current directory */
            const bool useCurrentWorkingDirectory = IsCurrentDirNotSystem32();

            hr = g_wslApi.WslLaunchInteractive(L"", useCurrentWorkingDirectory, &exitCode);

            // Check exitCode to see if wsl.exe returned that it could not start the Linux process
            // then prompt users for input so they can view the error message.
            if (SUCCEEDED(hr) && exitCode == UINT_MAX)
            {
                Helpers::PromptForInput();
            }
        }
        else if (arguments[0] == ARG_RUN ||
            arguments[0] == ARG_RUN_C)
        {
            std::wstring command;
            for (size_t index = 1; index < arguments.size(); index += 1)
            {
                command += L" ";
                command += arguments[index];
            }

            hr = g_wslApi.WslLaunchInteractive(command.c_str(), true, &exitCode);
        }
        else if (arguments[0] == ARG_SYSTEMD ||
            arguments[0] == ARG_SYSTEMD_D)
        {
            const std::wstring command = L"sudo start-systemd";
            hr = g_wslApi.WslLaunchInteractive(command.c_str(), true, &exitCode);
        }
        else if (arguments[0] == ARG_CONFIG)
        {
            hr = E_INVALIDARG;
            if (arguments.size() == 3)
            {
                if (arguments[1] == ARG_CONFIG_DEFAULT_USER)
                {
                    hr = SetDefaultUser(arguments[2]);
                }
            }

            if (SUCCEEDED(hr))
            {
                exitCode = 0;
            }
        }
        else
        {
            // ReSharper disable once CppFunctionResultShouldBeUsed
            Helpers::PrintMessage(MSG_USAGE);
            return static_cast<int>(exitCode);
        }
    }

    // Run custom commands on each launch.
    // hr = g_wslApi.WslLaunchInteractive(L"sudo yum update", true, &exitCode);
    // if (FAILED(hr)) {
    //	return hr;
    // }

    // If an error was encountered, print an error message.
    if (FAILED(hr))
    {
        if (hr == HRESULT_FROM_WIN32(ERROR_LINUX_SUBSYSTEM_NOT_PRESENT))
        {
            Helpers::PrintMessage(MSG_MISSING_OPTIONAL_COMPONENT);
        }
        else if (hr == HCS_E_HYPERV_NOT_INSTALLED)
        {
            Helpers::PrintMessage(MSG_ENABLE_VIRTUALIZATION);
        }
        else
        {
            Helpers::PrintErrorMessage(hr);
        }

        if (arguments.empty())
        {
            Helpers::PromptForInput();
        }
    }

    return SUCCEEDED(hr) ? exitCode : 1;
}
