#!/bin/bash

# check whether it is WSL1 for WSL2
if [[ -n ${WSL_INTEROP} ]]; then
  #Export an enviroment variable for helping other processes
  export WSL2=1
  # enable external x display for WSL 2

  ipconfig_exec=$(wslpath "C:\\Windows\\System32\\ipconfig.exe")
  if ( which ipconfig.exe >/dev/null ); then
    ipconfig_exec=$(which ipconfig.exe)
  fi

  wsl2_d_tmp="$(eval "$ipconfig_exec" | grep -n -m 1 "Default Gateway.*: [0-9a-z]" | cut -d : -f 1)"
  if [[ ${wsl2_d_tmp} ]]; then
    wsl2_d_tmp="$(eval "$ipconfig_exec" | sed ''"$(expr $wsl2_d_tmp - 4)"','"$(expr $wsl2_d_tmp + 0)"'!d' | grep IPv4 | cut -d : -f 2 | sed -e "s|\s||g" -e "s|\r||g")"
    export DISPLAY=${wsl2_d_tmp}:0.0
  else
    export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0
  fi

  unset wsl2_d_tmp
  unset ipconfig_exec
else
  # enable external x display for WSL 1
  export DISPLAY=:0
fi

# enable external libgl if mesa is not installed
if ( which glxinfo > /dev/null 2>&1 ); then
  unset LIBGL_ALWAYS_INDIRECT
else
  export LIBGL_ALWAYS_INDIRECT=1
fi

# speed up some GUI apps like gedit
export NO_AT_BRIDGE=1

# Fix 'clear' scrolling issues
alias clear='clear -x'

# Custom aliases
alias ll='ls -al'

# Check if we have Windows Path
if ( which cmd.exe >/dev/null 2>&1 ); then

  # Create a symbolic link to the windows home

  # Here have a issue: %HOMEDRIVE% might be using a custom set location
  # moving cmd to where Windows is installed might help: %SYSTEMDRIVE%
  wHomeWinPath=$(cmd.exe /c 'cd %SYSTEMDRIVE%\ && echo %HOMEDRIVE%%HOMEPATH%' 2>/dev/null | tr -d '\r')
  export WIN_HOME=$(wslpath -u "${wHomeWinPath}")

  win_home_lnk=${HOME}/winhome
  if [ ! -e "${win_home_lnk}" ] ; then
    ln -s -f "${WIN_HOME}" "${win_home_lnk}"
  fi

  unset win_home_lnk

fi
