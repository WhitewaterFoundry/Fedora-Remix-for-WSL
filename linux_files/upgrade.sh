#!/usr/bin/env bash

BASE_URL="https://raw.githubusercontent.com/WhitewaterFoundry/fedora-remix-rootfs-build/master/"
sha256sum /usr/local/bin/upgrade.sh >/tmp/sum.txt
sudo curl -L -f "${BASE_URL}/linux_files/upgrade.sh" -o /usr/local/bin/upgrade.sh
sudo chmod +x /usr/local/bin/upgrade.sh
sha256sum -c /tmp/sum.txt

CHANGED=$?
rm -r /tmp/sum.txt

# the script has changed? run the newer one
if [ ${CHANGED} -eq 1 ]; then
  echo Running the updated script
  bash /usr/local/bin/upgrade.sh
  exit 0
fi

sudo rm -f /etc/yum.repos.d/wslutilties.repo
sudo rm -f /var/lib/rpm/.rpm.lock
sudo dnf -y update
sudo rm -f /var/lib/rpm/.rpm.lock

# WSLU 3 is not installed
if [ "$(wslsys -v | grep -c "v3\.")" -eq 0 ]; then
  (
    source /etc/os-release && sudo dnf -y copr enable wslutilities/wslu "${ID_LIKE}"-"${VERSION_ID}"-"$(uname -m)"
  )
  sudo rm -f /var/lib/rpm/.rpm.lock
  sudo dnf -y update wslu
  sudo rm -f /var/lib/rpm/.rpm.lock
fi

# Update the release and main startup script files
sudo curl -L -f "${BASE_URL}/linux_files/00-remix.sh" -o /etc/profile.d/00-remix.sh

(
  source /etc/os-release
  sudo curl -L -f "${BASE_URL}/linux_files/os-release-${VERSION_ID}" -o /etc/os-release
)

# Add local.conf to fonts
sudo curl -L -f "${BASE_URL}/linux_files/local.conf" -o /etc/fonts/local.conf

# Fix a problem with the current WSL2 kernel
if [[ $( dnf info --installed iproute | grep -c '5.8' ) == 0 ]]; then
  sudo dnf install -y iproute-5.8.0 > /dev/null 2>&1
fi
