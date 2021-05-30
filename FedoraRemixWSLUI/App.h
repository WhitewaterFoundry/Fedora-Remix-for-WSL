#pragma once
#include "App.xaml.g.h"

namespace winrt::FedoraRemixWSLUI::implementation
{
    struct App : AppT<App>
    {
        App();

        void OnLaunched(const Windows::ApplicationModel::Activation::LaunchActivatedEventArgs&);
        void OnSuspending(const IInspectable&, const Windows::ApplicationModel::SuspendingEventArgs&);
        void OnNavigationFailed(const IInspectable&, const Windows::UI::Xaml::Navigation::NavigationFailedEventArgs&);
        fire_and_forget SetupPushNotifications() const;
        void OnActivated(const Windows::ApplicationModel::Activation::IActivatedEventArgs&);
    };
}
