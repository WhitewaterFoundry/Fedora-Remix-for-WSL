#!/bin/bash

set -e
ORIGINDIR=$(pwd)
TMPDIR=$(mktemp -d)
ARCH="x64"

set -x

cd $TMPDIR
mkdir $TMPDIR/dist

mkdir -m 0755 $TMPDIR/dist/dev
#mount --bind /dev $TMPDIR/dist/dev
#mock --init --rootdir=$TMPDIR/dist
mock --init --dnf --rootdir=$TMPDIR/dist
mount --bind /dev $TMPDIR/dist/dev
dnf --installroot=$TMPDIR/dist --releasever=/ -y groupinstall core --exclude=grub\*
umount $TMPDIR/dist/dev
#mock --dnf --install coreutils
#mkdir -m 755 $CHROOTDIR/dev/
#mknod -m 600 $CHROOTDIR/dev/console c 5 1
#mknod -m 600 $CHROOTDIR/dev/initctl p
#mknod -m 666 $CHROOTDIR/dev/full c 1 7
#mknod -m 666 $CHROOTDIR/dev/null c 1 3
#mknod -m 666 $CHROOTDIR/dev/ptmx c 5 2
#mknod -m 666 $CHROOTDIR/dev/random c 1 8
#mknod -m 666 $CHROOTDIR/dev/tty c 5 0
#mknod -m 666 $CHROOTDIR/dev/tty0 c 4 0
#mknod -m 666 $CHROOTDIR/dev/urandom c 1 0
#mknod -m 666 $CHROOTDIR/dev/zero c 1 5

#dnf --installroot=$CHROOTDIR --releasever=/ -y install coreutils
#dnf -c /etc/dnf/dnf.conf --installroot=$CHROOTDIR --releasever=/ --setopt=group_package_types=mandatory -y groupinstall "Core" --exclude=grub\*
#dnf -c /etc/dnf/dnf/conf --installroot=$CHROOTDIR -y install passwd sudo dnf
#dnf -c /etc/dnf/dnf.conf --installroot=$CHROOTDIR -y clean all

#cat > $CHROOTDIR/etc/sysconfig/network <<EOF
#NETWORKING=yes
#HOSTNAME=localhost.localdomain
#EOF

# Copy our own files
cp $ORIGINDIR/linux_files/wsl.conf $TMPDIR/dist/etc/wsl.conf
cp $ORIGINDIR/linux_files/local.conf $TMPDIR/dist/etc/local.conf

cd $TMPDIR/dist
tar --numeric-owner -czvf $ORIGINDIR/$ARCH/install.tar.gz *
rm -rf $TMPDIR
