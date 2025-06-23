<img src="https://fedoraproject.org/w/uploads/f/f9/Fedora_remix_purple.png" height=25% width=25%>

# Fedora Remix for Windows Subsystem for Linux (WSL)

Fedora Remix for WSL is a remix of upstream [Fedora](https://getfedora.org/) software for [Windows Subsystem for Linux](https://github.com/sirredbeard/Awesome-WSL) on Windows 10 and Windows 10 Server.

Fedora Remix for WSL is powered by [Pengwin Enterprise](https://github.com/WhitewaterFoundry/WLE) from [Whitewater Foundry](https://www.whitewaterfoundry.com/). Fedora Remix for WSL is not endorsed by the Fedora Project or Red Hat, Inc. but is provided under the [Fedora Remix](https://fedoraproject.org/wiki/Remix) program.

Fedora Remix for WSL contains modifications to the official Fedora distribution. The unmodified Fedora distribution can be obtained [here](https://getfedora.org/). Fedora Remix for WSL does not include pengwin-setup or other [features](https://github.com/WhitewaterFoundry/Pengwin#features) of [Pengwin](https://github.com/WhitewaterFoundry/Pengwin).

Fedora Remix for WSL is provided on a community-support basis. There is no support available for Fedora Remix for WSL from the Fedora community other than that which is offered to all users.

<a href="https://apps.microsoft.com/detail/Fedora%20Remix%20for%20WSL/9n6gdm4k2hnc?launch=true&cid=github&mode=full">
  <img src="https://get.microsoft.com/images/en-us%20dark.svg" width="200"/>
</a>

## Documentation

### General WSL and Fedora documentation:

- [Install Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
- [Fedora 36 User Documentation](https://docs.fedoraproject.org/en-US/fedora/f36/)
- [Fedora Project Wiki](https://fedoraproject.org/wiki/Fedora_Project_Wiki)
- [Fedora Project IRC](https://fedoraproject.org/wiki/IRC)
- [Fedora Project: How to file a bug report](https://fedoraproject.org/wiki/How_to_file_a_bug_report)
- [Fedora Packages Search](https://apps.fedoraproject.org/packages/)
- [DNF](https://fedoraproject.org/wiki/DNF) (Fedora package manager)
- [Awesome WSL](https://github.com/sirredbeard/Awesome-WSL)

### Differences from upstream Fedora:

- Fedora Remix for WSL is based on the [@core package group](https://fedoraproject.org/wiki/SIGs/Minimal_Core) from Fedora.
- The following packages have been removed from the default install of Fedora Remix for WSL: `grub`, `plymouth`, `kernel`, `sssd`, `linux-firmware`, `dracut`, `parted`, `e2fsprogs`, `iprutils`, `ppc64-utils`, `selinux-policy`, `policycoreutils`, `sendmail`, `firewalld`, `fedora-release`, `fedora-logos`, and `fedora-release-notes`.
- The following non-default package has been added to the default install to comply with the Fedora Remix program's terms: `generic-release`.
- The following configuration files have custom settings applied for the WSL environment: `/etc/wsl.conf`, `/etc/local.conf`, and `/etc/profile`.
- The following files have been removed and will be automatically re-generated if/as needed: `/etc/resolv.conf`, `/boot`, and `/var/cache/dnf/*`.

### Troubleshooting and support options:

1. [Basic troubleshooting](https://docs.microsoft.com/en-us/windows/wsl/troubleshooting) will solve many problems encountered with WSL.
1. You can search for your issue on the main [WSL issues](https://github.com/Microsoft/WSL/issues) page.
1. You may also [open an issue](https://github.com/WhitewaterFoundry/WSLFedoraRemix/issues/new/choose) here on our GitHub page for community support.

Whitewater Foundry devs monitor the Fedora Remix for WSL GitHub issues page; however, users who require dedicated end-user support for WSL should consider [Pengwin](https://github.com/WhitewaterFoundry/Pengwin) instead. Businesses and other organizations that would like to receive ongoing professional support should [e-mail us](mailto:enterprise@whitewaterfoundry.com) or visit [our website](https://www.whitewaterfoundry.com/wlinux-enterprise-edition/) to learn more about Pengwin Enterprise.

### In-place Upgrading
You can upgrade your existing installation of Fedora Remix with the following steps. 

First, backup your installation:

`wsl --export fedoraremix fedoraremix_backup.tar.gz`

Then proceed:

> NOTE: DO NOT PERFORM THE UPGRADE STARTING FEDORA REMIX WITH SYSTEMD; IT WILL RUIN YOUR INSTALLATION

#Be sure that systemd is disabled
`[ "$(grep -c "^systemd.*=.*true$" /etc/wsl.conf)" -ne 0 ] && sudo sed -i "s/^systemd.*=.*true$/systemd=false/" /etc/wsl.conf && wsl.exe --terminate ${WSL_DISTRO_NAME}`

```bash
next_version=$(echo "${VERSION_ID}+1" | bc)

update.sh 
sudo dnf -y upgrade --refresh  
sudo dnf -y install dnf-plugin-system-upgrade  
sudo rpm --import https://src.fedoraproject.org/rpms/fedora-repos/raw/rawhide/f/RPM-GPG-KEY-fedora-${next_version}-primary  
sudo dnf -y install distribution-gpg-keys 
sudo dnf -y system-upgrade --allowerasing --skip-broken download --releasever=${next_version}  
sudo dnf -y system-upgrade reboot

# At this point, it will raise an error, ignore it, and execute the following commands:

sudo dnf -y system-upgrade upgrade   
sudo dnf -y autoremove   
sudo dnf -y clean all   
sudo mandb  
update.sh  
cat /etc/fedora-release
exit
```

## About

### Fedora Project

- [Get Fedora](https://getfedora.org/)
- [Fedora’s Mission and Foundations](https://docs.fedoraproject.org/en-US/project/)
- [Fedora Magazine](https://fedoramagazine.org/)
- Twitter: [@fedora](https://twitter.com/fedora)
- [Planet Fedora](http://fedoraplanet.org/)
- [Fedora (Wikipedia)](https://en.wikipedia.org/wiki/Fedora_(operating_system))

### Whitewater Foundry, Ltd. Co.

[Whitewater Foundry, Ltd. Co.](https://www.whitewaterfoundry.com/) is an open-source startup that created Pengwin (formerly WLinux), the first Linux distribution designed for Windows Subsystem for Linux on Windows 10. Pengwin has since become a top developer tool on the Microsoft Store, and Whitewater Foundry has grown to a worldwide team of independent developers. Whitewater Foundry recently debuted Pengwin Enterprise and joined the Red Hat Business Partners program to offer a customizable, secure, and reliable WSL solution for large organizations powered by Red Hat Enterprise Linux.

- [Whitewater Foundry](https://www.whitewaterfoundry.com/)
- [Pengwin Enterprise](https://www.whitewaterfoundry.com/pengwin-enterprise/)
- Microsoft Store: [Pengwin](https://www.microsoft.com/en-us/p/wlinux/9nv1gv1pxz6p)
- Microsoft Store: [Pengwin Enterprise (Demo)](https://www.microsoft.com/en-us/p/wlinux-enterprise/9n8lp0x93vcp)
- Microsoft Store: [Fedora Remix for WSL](https://www.microsoft.com/en-us/p/fedora-remix-for-wsl/9n6gdm4k2hnc)
- Microsoft Store: [Raft WSL](https://www.microsoft.com/store/apps/9ND3HNW6PNDK)

### Isn't Fedora free?

Yes, Fedora is free. You should [go get it](https://getfedora.org/) and use it on your Linux workstation. We at Whitewater Foundry love Fedora and use it. Fedora Remix for WSL is not Fedora, though; it is a [remix](https://fedoraproject.org/wiki/Remix). The remix program allows individuals, groups, and companies to make Fedora derivatives for particular purposes that may contain modified/non-Fedora software. For example, there is the [Russian Fedora Remix](https://ru.fedoracommunity.org/stories/rfremix/), [FedBerry](http://fedberry.org/), and [Qubes OS](https://www.qubes-os.org/). We at Whitewater Foundry saw the demand for a Fedora distro for WSL. With [no official Fedora for WSL coming](https://twitter.com/mattdm/status/1058417653918896131), we invested the time and resources into making the Fedora Remix for WSL available as an alternative, building on our premium Pengwin Enterprise codebase. We charge for the official download through the Microsoft Store to continue optimizing, building, and packaging Fedora Remix for WSL, paying open-source developers, and building a sustainable open-source venture. Unlike Pengwin and Pengwin Enterprise, though, we also make signed downloads of Fedora Remix for WSL [available via GitHub](https://github.com/WhitewaterFoundry/WSLFedoraRemix/releases) that can be side-loaded for free.

<a href="https://apps.microsoft.com/detail/Fedora%20Remix%20for%20WSL/9n6gdm4k2hnc?launch=true&cid=github&mode=full">
  <img src="https://get.microsoft.com/images/en-us%20dark.svg" width="200"/>
</a>

## Legal

See [LICENSE.md](LICENSE.md) for important information on trademarks, copyright, patents, and software licensing.

See [BUILDING.md](BUILDING.md) for steps on how to build Fedora Remix for WSL from the source.
