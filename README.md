# WLinux Enterprise Edition

CentOS-compatible.

Goal:

- CentOS-compatible WSL distro.
- Includes WLinux config file tweaks.
- Does not include wlinux-setup.

Current Status:

- install.tar.gz builds
- WLE wrapper builds

Roadblock:

![Roadblock](https://github.com/sirredbeard/WLE/raw/master/Capture3.PNG)

- Need to figure out "networking" issue, either in build script or need to tweak DistributionInfo, see [what OpenSUSE did](https://build.opensuse.org/package/show/home:favogt:wsl-leap-15.0/wsl-launcher) in patches on their rpm-based distro for clues, also see [here](https://github.com/SequencesIO/WSL-DistroCentos7).

Todo:

- Add in WLinux config file tweaks.

Built images and .appx: 

- https://1drv.ms/f/s!AspPK83V8Sf2hehnsrw8p0a7rUkkJQ

CentOS VPS server for building images: 

- 45.76.248.144
- root
- T+4t7zPepCj?P@x+
