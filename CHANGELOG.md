## 43.0.0

### Highlights

* Updated to Fedora 43.
* Updated logo to the new Fedora Remix branding.
* First-run welcome message added (one-time per user) with support and upgrade guidance.
* Major WSL1 compatibility fixes for Fedora 43 (gdk-pixbuf/glycin workaround with pinning + cleanup).
* GNOME support removed due to lack of Xorg support; upgrade users must move to an alternative desktop.
* Updated default desktop selection (Xfce) and improved terminal profile behavior.
* Mesa install flow streamlined and updated for Fedora 43.

### Changes

#### Fedora 43 update

* Updated scripts/CI to support Fedora 43.

#### Desktop environments

* **Removed GNOME support** due to lack of Xorg support.
* Users upgrading from 42 will no longer be able to use GNOME.
* Recommended migration path: uninstall GNOME and install **Xfce**, **KDE**, or **LXDE**.

#### First-run UX (user experience)

* Added a one-time welcome message on first run for:

  * Bash/sh shells
  * fish
* Includes support resources, update recommendations, and WSL1-specific guidance.

#### WSL1 compatibility (Fedora 43)

* Implemented a targeted workaround for the Fedora 43 WSL1 gdk-pixbuf/glycin incompatibility:

  * Version pinning (to avoid incompatible combinations)
  * Removal of incompatible packages where needed
  * Cache refresh/rebuild steps
  * Executed both pre-update and post-update to reduce upgrade regressions

#### Mesa and graphics stack

* Updated Mesa installation logic and pinning to cover Fedora 43.
* Direct3D 12 acceleration is now available on ARM64 via an upstream Fedora change.
* Streamlined Mesa package lists in build and upgrade paths.

#### Terminal and session behavior

* Changed default desktop environment selection in the setup flow to **Xfce**.
* Improved terminal profile defaults to prevent the terminal from auto-closing on exit.
* Ensured shell history is flushed/saved before terminating WSL distributions in the desktop installer.

## 42.1.0

### Highlights

* XDG (base directories) now consistently defined and auto-created for better standards compliance.
* More reliable graphics/session bootstrap for WSLg: user runtime directories and audio paths are created/cleaned up safely.
* D-Bus session environment is isolated per-user via runtime directories, with tighter exported variables.
* Bash prompt logic rebuilt for clearer behavior and fewer side-effects.
* More robust repository configuration validation for the Fedora Remix repo.

### Changes

#### Environment + XDG

* Added `define_xdg_environment` to both shell init paths:

  * `linux_files/00-remix.sh`
  * `linux_files/00-remix.fish`
* Ensures XDG base directories are set and created when missing (improves app compatibility and reduces “missing dir” edge cases).
* Updated environment persistence (`save_environment`) to only save variables that are actually set (reduces noise and prevents invalid exports).

#### Display + runtime directory handling (WSLg/X11)

* Improved WSLg display setup to reliably manage `/run/user/$UID` plus PulseAudio runtime paths/symlinks.
* Added a new `create_userpath` helper + sudoers entry to create required runtime paths when needed, including cleanup of stale sockets and missing directories.
* Improved fallback logic to determine Windows host IP for X11 display using `route.exe` + `ip route` for higher reliability.

#### D-Bus session management

* D-Bus environment files now live under user-specific runtime directories (better isolation and security posture).
* Only necessary variables are exported and reused, reducing cross-session contamination.

#### Shell prompt + packaging

* Rewrote `linux_files/bash-prompt-wsl.sh`:

  * Applies prompt customization only in Bash and Windows Terminal.
  * Uses clearer constants and export logic to reduce unexpected prompt behavior.
* Ensures correct permissions for the new prompt script in `create-targz.sh`.

#### Repo configuration check

* Updated `linux_files/check-dnf` to directly modify repo files for disabling `gpgcheck` (more deterministic and scoped to the relevant repo).

42.0.4
* Make a workaround to an error in WSL 2.5.x that prevented the GPU video acceleration from working.

42.0.0
* Upgraded to Fedora 42
* Now systemd is enabled by default, and it's the recommended mode
* Upgraded to Mesa 25.0.4 and the D3D12 driver includes:
  * OpenGL 4.6 support completed
  * Expanded video encode/decode support (HEVC 4:2:2/4:4:4, H.264 Baseline)
  * Added VP9 and AV1 codecs in GPU Video Acceleration
* GNOME 48 with triple‑buffered rendering, notification stacking and well‑being timers
* XFCE 4.20 (experimental Wayland session) and LXQt 2.1 (default Wayland via Miriway) refresh the lightweight spins
* IBus 1.5.32 adds speech‑to‑text with offline VOSK models and Wayland‑IM‑v2 support
* GNU tool‑chain refresh: GCC 15, glibc 2.41, binutils 2.44, GDB 15+
* Ruby 3.4, PHP 8.4, Go 1.24, Haskell GHC 9.8/Stackage LTS 23, Tcl/Tk 9 all land as defaults
* DNF 5 gains automatic purge of expired / obsolete repo keys, plus ongoing performance work

41.0.0
* Upgraded to Fedora 41
* GNOME 47 and KDE Plasma 6.2
* Package updates such as LLVM 19, LXQt 2.0, Python 3.13, RPM 4.20, PyTorch 2.4, Perl 5.40, Golang 1.23, GIMP version 3
* dnf5: Faster, more efficient package manager.
* Upgraded to Mesa 24.2.5
* GIMP 3

40.1.0
* Upgraded to Mesa 24.1.2, and the Microsoft D3D12 driver now supports OpenGL 4.6
* Re-enabled the Windows Terminal Shell Integration due to the bug with version 1.21 was fixed.

40.0.3
* Be sure that the dbus-daemon is started once, regardless of the number of times that Fedora is invoked.
* Disabled the Windows Terminal Shell Integration until the bug with version 1.21 gets fixed.

40.0.1
* Upgraded to Fedora 40
* Upgraded to Mesa 24.0.5, and the Microsoft D3D12 driver now supports OpenGL 4.6
* Fixed a small typo in the fedoraremix.exe /? message

39.0.1
* A new script, "install-desktop.sh," allows installing GNOME, KDE, XFCE, or LXDE Desktops Environments with minimal manual steps or configuration.
* Improved Windows Terminal Shell Integration with built-in support for "Opening new tabs in the same working directory" and
  "Show marks for each command in the scrollbar," and by adding some actions in the settings.json file, "Automatically jump between commands," and "Select the entire output of a command."
* The color prompt has been improved, read /etc/profile.d/bash-color-prompt.sh to see what you can do with the PROMPT_* environment variables.
* [FIX] Now, if you configure Fedora Remix as your Default Profile in Windows Terminal, right-click a folder in File Explorer and select Open in Terminal, it will correctly open in the desired directory.

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
