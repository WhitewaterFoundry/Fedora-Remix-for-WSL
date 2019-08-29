#!/bin/bash

# Set environment
set -e
ORIGINDIR=$(pwd)
TMPDIR=$(mktemp -d)
ARCH=""
ARCHDIR=""
VER=30

function build {
# Install dependencies
dnf -y update
dnf -y install mock qemu-user-static
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
dnf --installroot=$TMPDIR/dist --forcearch=$ARCH -y install @core libgcc glibc-langpack-en --exclude=grub\*,sssd-common,sssd-client,linux-firmware,dracut*,e2fsprogs,iprutils,iptables,ppc64-utils,selinux-policy*,policycoreutils,sendmail,man-*,kernel*,fedora-release,fedora-logos,fedora-release-notes --allowerasing

# Unmount /dev
umount $TMPDIR/dist/dev

# Go to our origin directory to prepare to copy files
cd $ORIGINDIR

# Copy over some of our custom files
cp ./linux_files/dnf.conf $TMPDIR/dist/etc/dnf/dnf.conf
cp ./linux_files/wsl.conf $TMPDIR/dist/etc/wsl.conf
cp ./linux_files/local.conf $TMPDIR/dist/etc/local.conf
cp ./linux_files/remix.sh $TMPDIR/dist/etc/profile.d/remix.sh
cp ./linux_files/wslutilities.repo $TMPDIR/dist/etc/yum.repos.d/wslutilties.repo

# Comply with Fedora Remix terms
systemd-nspawn -q -D $TMPDIR/dist /bin/bash << EOF
dnf -y update
dnf -y install generic-release --allowerasing
EOF

# Overwrite os-release provided by generic-release
cp ./linux_files/os-release $TMPDIR/dist/etc/os-release

# Install cracklibs-dicts and wslutilities
systemd-nspawn -q -D $TMPDIR/dist /bin/bash << EOF
dnf -y install cracklib-dicts wslu
EOF

# Reinstall crypto-policies and clean up
systemd-nspawn -q -D $TMPDIR/dist /bin/bash << EOF
dnf -y reinstall crypto-policies --exclude=grub\*,dracut*,grubby,kpartx,kmod,os-prober,libkcapi*
dnf -y autoremove
dnf -y clean all
EOF

# Create filesystem tar, excluding unnecessary files
cd $TMPDIR/dist
tar --exclude='boot/*' --exclude='var/cache/dnf/*' --numeric-owner -czf $ORIGINDIR/$ARCHDIR/install.tar.gz *

# Return to origin directory
cd $ORIGINDIR

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
