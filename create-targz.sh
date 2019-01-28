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
sudo dnf install mock qemu-user-static

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
dnf --installroot=$TMPDIR/dist --forcearch=$ARCH -y groupinstall core --exclude=grub\*,sssd-kcm,sssd-common,sssd-client,linux-firmware,dracut*,plymouth,parted,e2fsprogs,iprutils,ppc64-utils,selinux-policy*,policycoreutils,sendmail,man-*,kernel*,firewalld,fedora-release,fedora-logos,fedora-release-notes --allowerasing

# Add additional necessary packages and comply with Fedora Remix terms
chroot $TMPDIR/dist dnf -y install cracklib-dicts generic-release --allowerasing

# Copy over some of our required files now that generic-release is installed
cp $ORIGINDIR/linux_files/dnf.conf $TMPDIR/dist/etc/dnf/dnf.conf
cp $ORIGINDIR/linux_files/os-release $TMPDIR/dist/etc/os-release

# Reinstall crypto-policies
chroot $TMPDIR/dist dnf -y reinstall crypto-policies

# Remove left over packages
chroot $TMPDIR/dist dnf -y autoremove

# Clean up
chroot $TMPDIR/dist dnf -y clean all

# Unmount /dev
umount $TMPDIR/dist/dev

# Final copy of our own custom configuration files
cp $ORIGINDIR/linux_files/wsl.conf $TMPDIR/dist/etc/wsl.conf
cp $ORIGINDIR/linux_files/local.conf $TMPDIR/dist/etc/local.conf

# Write some custom configuration
echo 'export DISPLAY=:0' >> $TMPDIR/dist/etc/profile
echo 'export LIBGL_ALWAYS_INDIRECT=1' >> $TMPDIR/dist/etc/profile
echo 'export NO_AT_BRIDGE=1' >> $TMPDIR/dist/etc/profile

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
