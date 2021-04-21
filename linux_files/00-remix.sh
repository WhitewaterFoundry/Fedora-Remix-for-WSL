#!/bin/bash

# Only the default WSL user should run this script
if ! (id -Gn | grep -c "adm.*wheel\|wheel.*adm" >/dev/null); then
  return
fi

setup_display() {
  # check whether it is WSL1 or WSL2
  if [ -n "${WSL_INTEROP}" ]; then
    if [ -n "${DISPLAY}" ]; then
      #Export an enviroment variable for helping other processes
      export WSL2=1

      return
    fi
    #Export an environment variable for helping other processes
    export WSL2=1
    # enable external x display for WSL 2

    ipconfig_exec=$(wslpath "C:\\Windows\\System32\\ipconfig.exe")
    if (command -v ipconfig.exe &>/dev/null); then
      ipconfig_exec=$(command -v ipconfig.exe)
    fi

    wsl2_d_tmp="$(eval "$ipconfig_exec 2> /dev/null" | grep -n -m 1 "Default Gateway.*: [0-9a-z]" | cut -d : -f 1)"

    if [ -n "${wsl2_d_tmp}" ]; then

      wsl2_d_tmp="$(eval "$ipconfig_exec" | sed "$((wsl2_d_tmp - 4))"','"$((wsl2_d_tmp + 0))"'!d' | grep IPv4 | cut -d : -f 2 | sed -e "s|\s||g" -e "s|\r||g")"
      export DISPLAY=${wsl2_d_tmp}:0
    else
      wsl2_d_tmp="$(grep </etc/resolv.conf nameserver | awk '{print $2}')"
      export DISPLAY=${wsl2_d_tmp}:0
    fi

    unset wsl2_d_tmp
    unset ipconfig_exec
  else
    # enable external x display for WSL 1
    export DISPLAY=localhost:0

    # Export an environment variable for helping other processes
    unset WSL2
  fi
}

setup_display

# enable external libgl if mesa is not installed
if (command -v glxinfo >/dev/null 2>&1); then
  unset LIBGL_ALWAYS_INDIRECT
else
  export LIBGL_ALWAYS_INDIRECT=1
fi

# if dbus-launch is installed then load it
if (command -v dbus-launch >/dev/null 2>&1); then
  eval "$(timeout 2s dbus-launch --auto-syntax)"
fi

# speed up some GUI apps like gedit
export NO_AT_BRIDGE=1

# Fix 'clear' scrolling issues
alias clear='clear -x'

# Custom aliases
alias ll='ls -al'

# Check if we have Windows Path
if (command -v cmd.exe >/dev/null 2>&1); then

  # Create a symbolic link to the windows home

  # Here have a issue: %HOMEDRIVE% might be using a custom set location
  # moving cmd to where Windows is installed might help: %SYSTEMDRIVE%
  wHomeWinPath=$(cmd.exe /c 'cd %SYSTEMDRIVE%\ && echo %HOMEDRIVE%%HOMEPATH%' 2>/dev/null | tr -d '\r')

  if [ ${#wHomeWinPath} -le 3 ]; then #wHomeWinPath contains something like H:\
    wHomeWinPath=$(cmd.exe /c 'cd %SYSTEMDRIVE%\ && echo %USERPROFILE%' 2>/dev/null | tr -d '\r')
  fi

  # shellcheck disable=SC2155
  export WIN_HOME=$(wslpath -u "${wHomeWinPath}")

  win_home_lnk=${HOME}/winhome
  if [ ! -e "${win_home_lnk}" ]; then
    ln -s -f "${WIN_HOME}" "${win_home_lnk}" >/dev/null 2>&1
  fi

  unset win_home_lnk

fi
