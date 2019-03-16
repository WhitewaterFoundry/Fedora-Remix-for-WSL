#!/bin/bash

# Set environment
set -e
ORIGINDIR=$(pwd)
TMPDIR=$(mktemp -d)
ARCH=""
ARCHDIR=""
VER=29

function build {
# Install dependencies
dnf install mock qemu-user-static
systemctl restart systemd-binfmt.service

# Move to our temporary directory
cd $TMPDIR
mkdir $TMPDIR/dist

# Make sure /dev is created before later mount
mkdir -m 0755 $TMPDIR/dist/dev

# Use mock to initialise chroot filesystem
mock --init --dnf --forcearch=$ARCH --rootdir=$TMPDIR/dist

# Bind mount current /dev to new chroot/dev
# (fixes '/dev/null: Permission denied' errors)
mount --bind /dev $TMPDIR/dist/dev

# Install required packages, exclude unnecessary packages to reduce image size
dnf --installroot=$TMPDIR/dist --forcearch=$ARCH -y install @core libgcc --exclude=grub\*,sssd-kcm,sssd-common,sssd-client,linux-firmware,dracut*,plymouth,parted,e2fsprogs,iprutils,ppc64-utils,selinux-policy*,policycoreutils,sendmail,man-*,kernel*,firewalld,fedora-release,fedora-logos,fedora-release-notes --allowerasing

# Add additional necessary packages, comply with Fedora Remix terms, reinstall crypto-policies, remove left over packages, and then clean up
if [ $ARCH = "aarch64" ]; then
	dnf --installroot=$TMPDIR/dist --forcearch=$ARCH -y install libgcc --allowerasing
fi

chroot $TMPDIR/dist dnf -y install cracklib-dicts generic-release --allowerasing
chroot $TMPDIR/dist dnf -y reinstall crypto-policies
chroot $TMPDIR/dist dnf -y autoremove
chroot $TMPDIR/dist dnf -y clean all

# Copy over some of our custom files
cp $ORIGINDIR/linux_files/dnf.conf $TMPDIR/dist/etc/dnf/dnf.conf
cp $ORIGINDIR/linux_files/os-release $TMPDIR/dist/etc/os-release
cp $ORIGINDIR/linux_files/wsl.conf $TMPDIR/dist/etc/wsl.conf
cp $ORIGINDIR/linux_files/local.conf $TMPDIR/dist/etc/local.conf
cp $ORIGINDIR/linux_files/remix.sh $TMPDIR/dist/etc/profile.d/remix.sh
cp $ORIGINDIR/linux_files/wslutilities.repo $TMPDIR/dist/etc/yum.repos.d/wslutilties.repo

chroot $TMPDIR/dist dnf -y update
chroot $TMPDIR/dist dnf -y install wslu

# Stop gpg and unmount /dev
umount $TMPDIR/dist/dev

# Create filesystem tar, excluding unnecessary files
cd $TMPDIR/dist
tar --exclude='boot/*' --exclude='var/cache/dnf/*' --numeric-owner -czvf $ORIGINDIR/$ARCHDIR/install.tar.gz *

# Cleanup
rm -rf $TMPDIR
}

function usage {
echo "./create-targz.sh <BUILD_ARCHITECTURE>"
echo "Possible architectures: arm64, x86_64"
}

# Accept argument input for architecture type
ARCH=$@
if [ "$ARCH" = "x86_64" ] ; then
	ARCH="x86_64"
	ARCHDIR="x64"
	build
elif [ "$ARCH" = "arm64" ] ; then
	ARCH="aarch64"
	ARCHDIR="ARM64"
	build
else
	usage
fi
