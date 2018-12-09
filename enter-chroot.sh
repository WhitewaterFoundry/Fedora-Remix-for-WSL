#!/bin/bash

ORIGDIR=$(pwd)
ARCH=x64
TARDIR=$ORIGDIR/$ARCH

# Set up temporary directory for chroot
cd $TARDIR
mkdir dist
cp install.tar.gz dist/install.tar.gz
cd dist

# Unpack filesystem
tar -xvf install.tar.gz
rm install.tar.gz

# Bind mount /dev
mount --bind /dev $TARDIR/dist/dev
chroot $TARDIR/dist
