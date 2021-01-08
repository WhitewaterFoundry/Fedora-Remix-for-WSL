#!/usr/bin/fish

# Only the default WSL user should run this script
if not id -Gn | string match -rq 'adm.*wheel|wheel.*adm'
    exit
end

# check whether it is WSL1 or WSL2
if [ -n $WSL_INTEROP ]
    #Export an environment variable for helping other processes
    set -x WSL2 1
    # enable external x display for WSL 2

    set ipconfig_exec (wslpath 'C:\Windows\System32\ipconfig.exe')
    if command -q ipconfig.exe
        set ipconfig_exec (command -s ipconfig.exe)
    end

    set wsl2_d_tmp ($ipconfig_exec ^/dev/null | grep -n -m 1 "Default Gateway.*: [0-9a-z]" | cut -d : -f 1)

    if [ -n $wsl2_d_tmp ]

        set wsl2_d_tmp ($ipconfig_exec ^/dev/null | sed (math $wsl2_d_tmp - 4)','(math $wsl2_d_tmp + 0)'!d' | string replace -fr '^.*IPv4.*:\s*(\S+).*$' '$1')
        set -x DISPLAY $wsl2_d_tmp:0
    else
        set wsl2_d_tmp (grep nameserver /etc/resolv.conf | awk '{print $2}')
        set -x DISPLAY $wsl2_d_tmp:0
    end

    set -e wsl2_d_tmp
    set -e ipconfig_exec
else
    # enable external x display for WSL 1
    set -x DISPLAY localhost:0

    # Export an environment variable for helping other processes
    set -e WSL2
end

# enable external libgl if mesa is not installed
if command -q glxinfo
    set -e LIBGL_ALWAYS_INDIRECT
else
    set -x LIBGL_ALWAYS_INDIRECT 1
end

# if dbus-launch is installed then load it
if command -q dbus-launch
  set -x DBUS_SESSION_BUS_ADDRESS (timeout 2s dbus-launch sh -c 'echo "$DBUS_SESSION_BUS_ADDRESS"')
end

# speed up some GUI apps like gedit
set -x NO_AT_BRIDGE 1

# Fix 'clear' scrolling issues
alias clear='clear -x'

# Custom aliases
# Removing ll='ls -al' since fish provides this out of the box.
#alias ll='ls -al'

# Check if we have Windows Path
if command -q cmd.exe

    # Create a symbolic link to the windows home

    # Here have a issue: %HOMEDRIVE% might be using a custom set location
    # moving cmd to where Windows is installed might help: %SYSTEMDRIVE%
    set wHomeWinPath (cmd.exe /c 'cd %SYSTEMDRIVE%\ && echo %HOMEDRIVE%%HOMEPATH%' ^/dev/null | string replace -a \r '')

    # shellcheck disable=SC2155
    set -x WIN_HOME (wslpath -u $wHomeWinPath)

    set win_home_lnk $HOME/winhome
    if [ ! -e $win_home_lnk ]
        ln -s -f $WIN_HOME $win_home_lnk &>/dev/null
    end

    set -e win_home_lnk

end
