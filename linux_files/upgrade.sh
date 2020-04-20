#!/usr/bin/env bash

sha256sum /usr/local/bin/upgrade.sh >/tmp/sum.txt
sudo curl -f https://raw.githubusercontent.com/WhitewaterFoundry/Fedora-Remix-for-WSL/master/linux_files/upgrade.sh -o /usr/local/bin/upgrade.sh
sha256sum -c /tmp/sum.txt

RESULT=$?
rm -r /tmp/sum.txt

# the script has changed? run the newer one
if [[ ! ${RESULT} ]]; then
  bash /usr/local/bin/upgrade.sh
  exit 0
fi

sudo curl -f https://raw.githubusercontent.com/WhitewaterFoundry/Fedora-Remix-for-WSL/master/linux_files/00-remix.sh -o /etc/profile.d/00-remix.sh
sudo curl -f https://raw.githubusercontent.com/WhitewaterFoundry/Fedora-Remix-for-WSL/master/linux_files/os-release -o /etc/os-release

sudo rm -f /etc/yum.repos.d/wslutilties.repo
(
  sudo rm /var/lib/rpm/.rpm.lock
  source /etc/os-release && sudo dnf -y copr enable wslutilities/wslu "${ID_LIKE}"-"${VERSION_ID}"-"$(uname -m)"
)
sudo rm -f /var/lib/rpm/.rpm.lock
sudo dnf -y update wslu

sudo rm -f /var/lib/rpm/.rpm.lock
sudo dnf -y update

sudo rm -f /var/lib/rpm/.rpm.lock
sudo dnf -y update

