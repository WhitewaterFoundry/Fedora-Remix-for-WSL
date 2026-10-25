# Changelog

All notable changes to Fedora Remix for WSL are documented in this file.

## [44.0.0] - 2026-10-25

### Added

- Added Fedora 44 root filesystem builds and release metadata for x64 and ARM64. ([rootfs change](https://github.com/WhitewaterFoundry/fedora-remix-rootfs-build/commit/48abde7edc45ef2dff69f2d0937e028178a89e4c))
- Added an interactive GNOME desktop installer for Fedora 44 on WSL 2.
- Added native headless GNOME Wayland sessions using GNOME Remote Desktop instead of xrdp.
- Added guided configuration for the hostname, RDP port, RDP username, and RDP password.
- Added automatic self-signed TLS certificate generation for RDP.
- Added connection support through `localhost`, the configured `.local` hostname, or the WSL IP address.
- Added automatic configuration of systemd, Avahi, Xwayland compatibility, and the GNOME headless-session services. ([desktop implementation](https://github.com/WhitewaterFoundry/fedora-remix-rootfs-build/commit/bddefba6775c572daf008cd91aeb23186e03b17c))
- Added `install-desktop-xorg.sh` to preserve the existing Xorg/xrdp desktop setup on Fedora Remix 43 and earlier. ([legacy installer](https://github.com/WhitewaterFoundry/fedora-remix-rootfs-build/commit/32c4b8d29b7fb7e69ad6b9c5afb83db032874ad1))
- Added `systemd-pam` to new root filesystems and WSL 2 upgrades. ([upgrade support](https://github.com/WhitewaterFoundry/fedora-remix-rootfs-build/commit/a84949f5bfea0cb8c9bb394029d032c5a308604a))
- Added Fedora 44 support for the WSL-specific Mesa 26.2.4 graphics packages on x86_64. ([Mesa update](https://github.com/WhitewaterFoundry/fedora-remix-rootfs-build/commit/e7278d98bd23a856d13edeaf587ee32cbfdb3dad))
- Added the `render` group to newly created Linux users. ([launcher changes](https://github.com/WhitewaterFoundry/Fedora-Remix-for-WSL/commit/39273eade5388aee82bd046db4bc53b19d7674be))

### Changed

- Changed the default root filesystem build target from Fedora 43 to Fedora 44.
- Changed the Windows package version from 43.0.1.0 to 44.0.0.0.
- Changed Fedora 44 desktop installation from xrdp/Xorg to GNOME Remote Desktop with a headless Wayland session.
- Changed the desktop installer to require WSL 2 and execution as a regular Linux user.
- Changed Bash and Fish session initialization to recognize headless desktop sessions and restore only the required WSL variables.
- Changed WSL interoperability detection so restarted and remote sessions refresh the active interoperability socket without replacing their display or audio environment. ([environment handling](https://github.com/WhitewaterFoundry/fedora-remix-rootfs-build/commit/532e4928889c5843d987600ac2f8704315262533))
- Changed `mesa-va-drivers` installation to a separate package-management operation to avoid dependency-resolution failures. ([VA-driver fix](https://github.com/WhitewaterFoundry/fedora-remix-rootfs-build/commit/97ccd1507992d68514c22bf6b61b5d00237bf2bd))
- Changed newly created users to use `/bin/bash` explicitly as their login shell.
- Changed failed password setup handling so incomplete user accounts are removed automatically.
- Updated Microsoft C++/WinRT to 3.0.260818.1.
- Updated Windows projects to Platform Toolset v145.
- Updated Azure Pipelines to the `windows-2025-vs2026` image.
- Updated package publisher and signing-certificate information. ([toolchain update](https://github.com/WhitewaterFoundry/Fedora-Remix-for-WSL/commit/0b2ccd7b35bc840d9712bc33138fc5740a5496a8), [signing update](https://github.com/WhitewaterFoundry/Fedora-Remix-for-WSL/commit/c5040f305bb49193580e0cc2a4d8bbcfbc7fe9ac))

### Fixed

- Fixed GNOME Remote Desktop startup failures caused by Mesa’s D3D12 Vulkan driver.
- Fixed GTK 4 rendering problems in headless sessions by selecting the OpenGL renderer.
- Fixed Xwayland startup when WSLg mounts `/tmp/.X11-unix` as read-only.
- Fixed remote sessions overwriting their own Wayland, display, and audio variables with values captured from a terminal session.
- Fixed GNOME Remote Desktop settings being silently discarded when no writable runtime directory or user D-Bus session was available.
- Fixed WSL 1 upgrades on Fedora 43 and later when `gdk-pixbuf2` and Glycin require the unavailable `memfd` system call.
- Added automatic installation or downgrade to compatible `gdk-pixbuf2` 2.42 packages on affected WSL 1 installations.
- Added package locks to prevent incompatible `gdk-pixbuf2`, Glycin, and Mesa updates. ([WSL 1 fix](https://github.com/WhitewaterFoundry/fedora-remix-rootfs-build/commit/303e26cc87a8cabf03b661d93936cca2694b50ea), [final refinement](https://github.com/WhitewaterFoundry/fedora-remix-rootfs-build/commit/4decbaf27ad5d372106833a5a2a3ec74e7792f58))

### Removed

- Removed KDE Plasma from the Fedora 44 desktop selection menu because KRdp authentication with Windows Remote Desktop is not yet reliable. ([KDE menu change](https://github.com/WhitewaterFoundry/fedora-remix-rootfs-build/commit/126e183eda9cebd155281b8c9bb394029d032c5a308604a))
- Removed obsolete launcher reset-detection logic.
- Removed unused Windows packaging project references.

### Known limitations

- The Fedora 44 desktop installer supports WSL 2 only.
- GNOME is the only supported desktop option presented by the Fedora 44 installer.
- The first RDP connection displays a warning because the installer uses a self-signed certificate.
- Keep a Fedora Remix terminal or another WSL process open while using the remote desktop. WSL may stop the distribution when no process remains active.
- Windows App compatibility was reported during development, but the current installer documentation specifically describes connecting with Remote Desktop Connection (`mstsc.exe`).
- The existing no-window launcher was not introduced or materially changed in this release.
- `update.sh` updates Fedora Remix scripts and compatibility packages but does not by itself upgrade an existing installation to a new Fedora major version.

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
