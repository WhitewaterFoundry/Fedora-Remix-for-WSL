#!/bin/bash
echo "Finish installing wslutilities..."
sudo dnf -y update
sudo dnf -y install wslu
rm /etc/profile.d/armfirstrun.sh