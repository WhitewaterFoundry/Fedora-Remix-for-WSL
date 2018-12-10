#!/bin/bash

# Set environment
set -e
ORIGINDIR=$(pwd)
TMPDIR=$(mktemp -d)
ARCH=""
ARCHDIR=""
VER=29

function build {
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

# Install required packages
dnf --installroot=$TMPDIR/dist --forcearch=$ARCH --releasever=$VER -y groupinstall core --exclude=grub\*,sssd-kcm,sssd-common,sssd-client

# Run dnf update from chroot to ensure filesystem build working
chroot $TMPDIR/dist dnf -y update

# Install extra, remove  unnecessary then clean (reduce FS size)
chroot $TMPDIR/dist dnf -y install cracklib-dicts
chroot $TMPDIR/dist dnf -y remove linux-firmware dracut plymouth parted
chroot $TMPDIR/dist dnf -y autoremove
chroot $TMPDIR/dist dnf -y clean all

# Unmount /dev
umount $TMPDIR/dist/dev

# Copy our own files
cp $ORIGINDIR/linux_files/wsl.conf $TMPDIR/dist/etc/wsl.conf
cp $ORIGINDIR/linux_files/local.conf $TMPDIR/dist/etc/local.conf

# Delete resolv.conf to let Windows generate it's own on first run
rm $TMPDIR/dist/etc/resolv.conf

# Create filesystem tar
cd $TMPDIR/dist
tar --numeric-owner -czvf $ORIGINDIR/$ARCHDIR/install.tar.gz *

# Cleanup
rm -rf $TMPDIR
}

function usage {
echo "./create-targz.sh <BUILD_ARCHITECTURE>"
echo "Possible architectures: arm64, x86_64"
}

# Accept argument input for architecture type
ARCH=$@
if [ "$ARCH" = "x64" ] ; then
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
