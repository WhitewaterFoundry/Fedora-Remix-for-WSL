#!/bin/bash

# Set environment
set -e
ORIGINDIR=$(pwd)
TMPDIR=$(mktemp -d)
ARCH="x64"
VER=29

# Move to our temporary directory
cd $TMPDIR
mkdir $TMPDIR/dist

# Make sure /dev is created before later mount
mkdir -m 0755 $TMPDIR/dist/dev

# Use mock to initialise chroot filesystem
mock --init --dnf --rootdir=$TMPDIR/dist

# Bind mount current /dev to new chroot/dev
# (fixes '/dev/null: Permission denied' errors)
mount --bind /dev $TMPDIR/dist/dev

# Install required packages
dnf --installroot=$TMPDIR/dist --releasever=$VER -y groupinstall core --exclude=grub\*

# Run dnf update from chroot to ensure filesystem build working
chroot $TMPDIR/dist dnf -y update

# Autoremove unnecessary packages then clean (reduce FS size)
chroot $TMPDIR/dist dnf -y autoremove
chroot $TMPDIR/dist dnf -y clean all
#dnf --installroot=$TMPDIR/dist --releasever=/ -y autoremove
#dnf --installroot=$TMPDIR/dist --releasever=/ -y clean all

# Unmount /dev
umount $TMPDIR/dist/dev

#cat > $CHROOTDIR/etc/sysconfig/network <<EOF
#NETWORKING=yes
#HOSTNAME=localhost.localdomain
#EOF

# Copy our own files
cp $ORIGINDIR/linux_files/wsl.conf $TMPDIR/dist/etc/wsl.conf
cp $ORIGINDIR/linux_files/local.conf $TMPDIR/dist/etc/local.conf

# Create filesystem tar
cd $TMPDIR/dist
tar --numeric-owner -czvf $ORIGINDIR/$ARCH/install.tar.gz *

# Cleanup
rm -rf $TMPDIR
