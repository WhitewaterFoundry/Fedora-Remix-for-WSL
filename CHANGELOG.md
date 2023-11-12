
39.0.0
* Upgraded to Fedora 39
* Fedora Linux 39 now features a coloured Bash prompt by default!
* Added experimental prompt escape sequences for Windows Terminal 1.18 Shell Integration.
* When the distro is being installed, now a progress icon appears in the Windows Terminal tab.
* Upgraded mesa to 23.1.9 with improvements in video decoding and encoding, also added AV1 support.

38.0.0
* Upgraded to Fedora 38
* Made a custom Mesa 23 compilation with Direct 3D 12 support and video codes

37.2.0
* Latest update for Fedora 37
* Upgraded mesa to 23.0.2 which includes some fixes to the VP9 video decoder

* 37.1.2
* Support GPU video decoding and encoding in WSLg

37.1.0
* Upgrade Mesa to 22.3.6
* Fix ping in WSL1
* Upgrade to WSL Utilities 4.1.1

37.0.4
* Stop trying to upgrade fedora remix if the SystemD script fails

37.0.2
* Upgraded to Fedora 37
* Improved compatibility with the Windows built-in SystemD

36.0.1
* Upgraded to Fedora 36

35.13.5
* Added SystemD optional support, adding an -s parameter to the fedoraremix.exe launcher.
* Added a new command wslsystemctl to start services without starting SystemD, as other distros like Ubuntu does with the service command.
* Added tweaks to be able to run snaps with WSLg.
* Added tweaks to be able to run GNOME Desktop using Remote Desktop Connection.

35.12.6
* Fix a launch error with Windows Terminal 1.12

35.12.5
* Added explicit error code and message for virtualization not present
* Improved the tiles in Start Menu in Windows 10 1809-1909

35.12.3
* Upgraded to Fedora 35
* Now the upgrade.sh script can be executed calling update.sh
* Fixed an error for some configurations that Fedora Remix cannot be executed from Windows Terminal
* Improved the logo in Windows 10 start menu
* Upgraded Mesa to 21.2.3, the latest version 21.3.1 provided by upstream Fedora 35 has a serious performance issue with GPU and WSLg

34.5.6
* Fixed a problem with dnf and WSL1
* Fixed a connection problem with XServer when fish is the default shell

34.5.5
* Automatically creates an entry with logo in Windows Terminal
* In App Settings, it is possible to set Fedora Remix launch at startup
* When a new distro is created, now the default user is written in wsl.conf. So, the default user is preserved on exports and imports
* For Windows Terminal add Fedora default color theme and background
* Fix a problem installing packages in WSL1
* Upgrade WSLU to 3.2.3
