# WLinux Enterprise Edition

CentOS-compatible WSL distro.

Goal:

- CentOS-compatible WSL distro template.
- Includes basic WLinux config file tweaks.
- Does not include wlinux-setup.

Current Status:

- install.tar.gz builds OK
- WLE wrapper builds OK

Roadblock:

![Roadblock](https://github.com/sirredbeard/WLE/raw/master/Capture3.PNG)

- Need to figure out "networking" issue above. "The specified network name is no longer available." is a Windows I/O error message, not a Windows one. Likely need to tweak DistributionInfo.h/.cpp.

Note: See edits OpenSUSE made [here](https://build.opensuse.org/package/view_file/home:favogt:wsl-leap-15.0/wsl-launcher/SUSE-distros.patch?expand=1).

Todo:

- Fix issue above.
- Fill in yum.conf.
- Fill in wslu.yum.conf.
- Fill in LICENSE.md details.
- Move to Whitewater Foundry account and open source.

Built images and .appx for testing: 

- https://1drv.ms/f/s!AspPK83V8Sf2hehmnS0fND3QWrE5_w 23 Nov

CentOS VPS server for building images: 

- 45.76.248.144
- root
- T+4t7zPepCj?P@x+
