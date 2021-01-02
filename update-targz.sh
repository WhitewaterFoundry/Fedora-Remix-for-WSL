#! /bin/bash

export PREBOOTSTRAP_ARCH="${1:-amd64}"
export PREBOOTSTRAP_QEMU_ARCH="${2:-x86_64}"
export PREBOOTSTRAP_RELEASE="${3:-testing}"
export BUILD_FOLDER="${4:-x64}"

source /etc/os-release

#Go Home
# shellcheck disable=SC2164
cd

echo 'Installing build dependencies'
sudo dnf -y update
sudo dnf -y install mock qemu-user-static

echo 'Creating rootfs folder'
mkdir rootfs

echo 'Extract previous rootfs, entering chroot to mount dev, sys, proc and dev/pts'
(
  # shellcheck disable=SC2164
  cd rootfs
  sudo tar -zxf /vagrant/"${BUILD_FOLDER}"/install.tar.gz

  sudo mkdir -p sys
  sudo mkdir -p proc
  sudo mkdir -p dev/pts

  sudo mount --bind /dev dev/
  sudo mount --bind /sys sys/
  sudo mount --bind /proc proc/
  sudo mount --bind /dev/pts dev/pts/
)

echo 'Copy static QEMU to rootfs'
sudo cp /usr/bin/qemu-"${PREBOOTSTRAP_QEMU_ARCH}"-static rootfs/usr/bin/

echo "Marking static [rootfs/usr/bin/qemu-${PREBOOTSTRAP_QEMU_ARCH}-static] as executable"
sudo chmod +x rootfs/usr/bin/qemu-"${PREBOOTSTRAP_QEMU_ARCH}"-static

echo 'Copy dns'
sudo cp /etc/resolv.conf rootfs/etc/

echo 'Setup WSLU'
sudo rm -f rootfs/etc/yum.repos.d/wslutilties.repo
(
  source rootfs/etc/os-release && sudo chroot rootfs/ dnf -y copr enable wslutilities/wslu "${ID_LIKE}"-"${VERSION_ID}"-"${PREBOOTSTRAP_QEMU_ARCH}"
)
sudo chroot rootfs/ dnf -y update wslu

echo 'Upgrade packages and install more'
sudo chroot rootfs/ dnf -y update

echo 'Clean up apt cache'
sudo chroot rootfs/ dnf -y reinstall crypto-policies --exclude=grub\*,dracut*,grubby,kpartx,kmod,os-prober,libkcapi*
sudo chroot rootfs/ dnf -y autoremove
sudo chroot rootfs/ dnf -y clean all

echo 'Copy files'
sudo cp /vagrant/linux_files/00-remix.sh rootfs/etc/profile.d/
sudo cp /vagrant/linux_files/os-release-"${VERSION_ID}" rootfs/etc/
sudo cp /vagrant/linux_files/upgrade.sh rootfs/usr/local/bin/
sudo cp /vagrant/linux_files/local.conf rootfs/etc/fonts/

sudo chmod +x rootfs/usr/local/bin/upgrade.sh

echo 'Deleting QEMU from chroot'
sudo rm rootfs/usr/bin/qemu-"${PREBOOTSTRAP_QEMU_ARCH}"-static

echo 'Compressing rootfs'
rm /vagrant/"${BUILD_FOLDER}"/install.tar.gz.bak
mv /vagrant/"${BUILD_FOLDER}"/install.tar.gz /vagrant/"${BUILD_FOLDER}"/install.tar.gz.bak
(
  # shellcheck disable=SC2164
  cd rootfs
  sudo tar -zcf /vagrant/"${BUILD_FOLDER}"/install.tar.gz --exclude proc --exclude dev --exclude sys --exclude='boot/*' --exclude='var/cache/dnf/*' --numeric-owner ./*
)