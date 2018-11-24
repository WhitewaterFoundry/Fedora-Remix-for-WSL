set -e

ORIGINDIR=$(pwd)
TMPDIR=$(mktemp -d)
BUILDDIR=$(mktemp -d)

# CentOS
BOOTISO="http://mirror.centos.org/centos/7.5.1804/os/x86_64/images/boot.iso"
KSFILE="https://raw.githubusercontent.com/CentOS/sig-cloud-instance-build/master/docker/centos-7.ks"

# CentOS ARM64
# BOOTISO="http://mirror.centos.org/altarch/7/os/aarch64/images/boot.iso"
# KSFILE="https://raw.githubusercontent.com/CentOS/sig-cloud-instance-build/master/docker/centos-7arm64.ks"

# Fedora
# BOOTISO="http://fedora.mirror.constant.com/fedora/linux/releases/29/Workstation/x86_64/iso/Fedora-Workstation-Live-x86_64-29-1.2.iso"
# KSFILE="https://pagure.io/fedora-kickstarts/raw/master/f/fedora-docker-base.ks"

# Oracle
# Download ISO from oracle.com. Comment out line 29 and edit --iso in line 33 to point to your downloaded ISO.
# KSFILE="https://gist.githubusercontent.com/bargenson/24e9c4883a4adbcfbfd4/raw/3c1aae56a6565c51ec674d61d041123134bab6c6/docker-oracle-linux.ks"

# RHEL
# Download ISO from redhat.com. Comment out line 29 and edit --iso in line 33 to point to your downloaded ISO.
# KSFILE="https://raw.githubusercontent.com/CentOS/sig-cloud-instance-build/master/docker/centos-7.ks"

cd $TMPDIR

sudo yum install libvirt lorax virt-install libvirt-daemon-config-network libvirt-daemon-kvm libvirt-daemon-driver-qemu

sudo systemctl restart libvirtd

sudo curl $BOOTISO -o /tmp/install.iso

curl $KSFILE -o install.ks

sudo livemedia-creator --make-tar --iso=/tmp/install.iso --image-name=install.tar.xz --ks=install.ks

tar -xvf /var/tmp/install.tar.xz -C $BUILDDIR

sudo cp $ORIGINDIR/linux_files/wsl.conf $BUILDDIR/etc/wsl.conf
sudo cp $ORIGINDIR/linux_files/local.conf $BUILDDIR/etc/local.conf
#sudo cp $ORIGINDIR/linux_files/wslu.yum.conf $BUILDDIR/etc/yum.conf.d/wslu.yum.conf

sudo bash -c "echo 'export DISPLAY=:0' >> $BUILDDIR/etc/profile"
sudo bash -c "echo 'export LIBGL_ALWAYS_INDIRECT=1' >> $BUILDDIR/etc/profile"
sudo bash -c "echo 'export NO_AT_BRIDGE=1' >> $BUILDDIR/etc/profile"

cd $BUILDDIR
tar --ignore-failed-read --numeric-owner -czvf $ORIGINDIR/install.tar.gz *

cd $ORIGINDIR

sudo rm -r $BUILDDIR
sudo rm -r $TMPDIR
sudo rm /tmp/install.iso
sudo rm /var/tmp/install.tar.xz