set -e

ORIGINDIR=$(pwd)
TMPDIR=$(mktemp -d)
BUILDDIR=$(mktemp -d)

# CentOS
BOOTISO="http://mirror.centos.org/centos/7.5.1804/os/x86_64/images/boot.iso"
KSFILE="https://raw.githubusercontent.com/CentOS/sig-cloud-instance-build/master/docker/centos-7.ks"

# Scientific Linux
# BOOTISO="http://ftp.lip6.fr/pub/linux/distributions/scientific/7x/x86_64/os/images/boot.iso"
# KSFILE="https://raw.githubusercontent.com/scientificlinux/sl-docker/7/sl7/sl7-container.ks"

# Fedora
# BOOTISO="http://fedora.mirror.constant.com/fedora/linux/releases/29/Workstation/x86_64/iso/Fedora-Workstation-Live-x86_64-29-1.2.iso"
# KSFILE="https://pagure.io/fedora-kickstarts/raw/master/f/fedora-docker-common.ks"

cd $TMPDIR

sudo yum install libvirt lorax virt-install libvirt-daemon-config-network libvirt-daemon-kvm libvirt-daemon-driver-qemu

sudo systemctl restart libvirtd

sudo curl $BOOTISO -o /tmp/install.iso

curl $KS -o install.ks

sudo livemedia-creator --make-tar --iso=/tmp/install.iso --image-name=install.tar.xz --ks=install.ks

tar -xvf /var/tmp/install.tar.xz -C $BUILDDIR

sudo cp $ORIGINDIR/linux_files/wsl.conf $BUILDDIR/etc/wsl.conf
#sudo cp $ORIGINDIR/linux_files/wslu.yum.conf $BUILDDIR/etc/yum.conf.d/wslu.yum.conf

sudo bash -c "echo 'export DISPLAY=:0' >> $BUILDDIR/etc/profile"
sudo bash -c "echo 'export LIBGL_ALWAYS_INDIRECT=1' >> $BUILDDIR/etc/profile"
sudo bash -c "echo 'export NO_AT_BRIDGE=1' >> $BUILDDIR/etc/profile"

tar --ignore-failed-read --numeric-owner -czvf install.tar.gz $BUILDDIR/*

sudo rm /tmp/install.iso