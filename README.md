# Fedora Remix for WSL

Fedora Remix for WSL is a remix of upstream [Fedora](https://getfedora.org/) software for [Windows Subsystem for Linux](https://github.com/sirredbeard/Awesome-WSL) on Windows 10 and Windows 10 Server.

Fedora Remix for WSL is powered by [WLinux Enterprise](https://github.com/WhitewaterFoundry/WLE) from [Whitewater Foundry](https://www.whitewaterfoundry.com/). Fedora Remix for WSL is not endorsed by the Fedora Project or Red Hat, Inc. but is provided under the [Fedora Remix](https://fedoraproject.org/wiki/Remix) program.

Fedora Remix for WSL contains modifications to the official Fedora distribution. The unmodified Fedora distribution can be obtained [here](https://getfedora.org/). Fedora Remix for WSL does not contain wlinux-setup or other features of [WLinux](https://github.com/WhitewaterFoundry/WLinux).

### Support

Fedora Remix for WSL is provided on the Microsoft Store for individual users on a self-support community-support basis. There is no support available for Fedora Remix for WSL specifically from the Fedora community other than that which is offered to all users.

Differences from upstream Fedora:

- The following packages have been removed from the default install: grub, sssd-kcm, sssd-common, sssd-client, linux-firmware, dracut, plymouth, parted, fedora-release, fedora-logos, and fedora-release-notes.
- The following non-default packages have been added to the default install: cracklib-dicts, generic-release, generic-logos, and generic-release-notes.
- The following configuration files have custom settings: /dist/etc/wsl.conf and /dist/etc/local.conf.
- The following files have been removed and will be automatically re-generated as needed: /dist/etc/resolv.conf and /var/cache/dnf/*.

Documentation:

- [Install Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
- [Fedora User Documentation](https://docs.fedoraproject.org/en-US/fedora/f29/)
- [Fedora Project Wiki](https://fedoraproject.org/wiki/Fedora_Project_Wiki)
- [DNF](https://fedoraproject.org/wiki/DNF)

Steps:

1. [Basic troubleshooting](https://docs.microsoft.com/en-us/windows/wsl/troubleshooting) will solve many problems encountered with WSL.
1. You can search for your issue in the main [WSL issues](https://github.com/Microsoft/WSL/issues) page.
1. You may also [open an issue](https://github.com/WhitewaterFoundry/WSLFedoraRemix/issues/new/choose) on our GitHub for community support.

Users who require dedicated end-user support should consider [WLinux](https://github.com/WhitewaterFoundry/WLinux) instead. Businesses and other organizations who would like to recieve professional ongoing support should [e-mail us](mailto:enterprise@whitewaterfoundry.com) or visit [our website](https://www.whitewaterfoundry.com/wlinux-enterprise-edition/) to learn more about WLinux Enterprise.

### About

Whitewater Foundry, Ltd. Co. is an open-source startup that created WLinux, the first Linux distribution designed for Windows Subsystem for Linux on Windows 10. WLinux has since become a top developer tool on the Microsoft Store and Whitewater Foundry has grown to a worldwide team of independent developers. Whitewater Foundry recently debuted WLinux Enterprise and joined the Red Hat Business Partners program to offer a customizable, secure, and reliable WSL solution for large organizations powered by Red Hat Enterprise Linux.

[whitewaterfoundry.com](https://www.whitewaterfoundry.com/wlinux-enterprise-edition/)<br>
contact@whitewaterfoundry.com

### Legal

See [LICENSE.md](LICENSE.md) for important information on trademarks, copyright, patents, and software licensing.

See [BUILDING.md](BUILDING.md) for steps on how to build Fedora Remix for WSL from source.

See [TODO.md](TODO.md) for current todos and issues related to this build.
