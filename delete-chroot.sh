#!/bin/bash

ORIGDIR=$(pwd)
ARCH=x64
TARDIR=$ORIGDIR/$ARCH

# Unmount /dev
umount $TARDIR/dist/dev

# Clear up filesystem directory
rm -rf $TARDIR/dist
