# WLinux Enterprise Edition

CentOS-compatible WSL distro.

Goal:

- CentOS-compatible WSL distro.
- Includes WLinux config file tweaks.
- Does not include wlinux-setup.

Current Status:

- install.tar.gz builds OK
- WLE wrapper builds OK

Roadblock:

![Roadblock](https://github.com/sirredbeard/WLE/raw/master/Capture3.PNG)

- Need to figure out "networking" issue above. "The specified network name is no longer available." is a Windows I/O error message, not a Windows one. Likely need to tweak DistributionInfo.h/.cpp.

Todo:

- Fix issue above.
- Add tweaks to create-targz-x64.sh:
    - DISPLAY=:0
    - LIBGL_ALWAYS_INDIRECT=1
    - NO_AT_BRIDGE=1
    - Copy wsl.conf to /etc/wsl.conf
    - Copy local.conf to /etc/local.conf
- Fill in LICENSE.md details.
- Move to Whitewater Foundry account and open source.

Built images and .appx for testing: 

- https://1drv.ms/f/s!AspPK83V8Sf2hehnsrw8p0a7rUkkJQ

CentOS VPS server for building images: 

- 45.76.248.144
- root
- T+4t7zPepCj?P@x+
