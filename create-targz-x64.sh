set -e

ORIGINDIR=$(pwd)
TMPDIR=$(mktemp -d)
BUILDDIR=$(mktemp -d)
cd $TMPDIR

sudo yum install libvirt lorax virt-install libvirt-daemon-config-network libvirt-daemon-kvm libvirt-daemon-driver-qemu

sudo systemctl restart libvirtd

sudo curl http://mirror.centos.org/centos/7.5.1804/os/x86_64/images/boot.iso -o /tmp/boot7.iso

curl https://raw.githubusercontent.com/CentOS/sig-cloud-instance-build/master/docker/centos-7.ks -o centos-7.ks

sudo livemedia-creator --make-tar --iso=/tmp/boot7.iso --image-name=install.tar.xz --ks=centos-7.ks

tar -xvf /var/tmp/install.tar.xz -C $BUILDDIR

sudo cp $ORIGINDIR/linux_files/wsl.conf $BUILDDIR/etc/wsl.conf
#sudo cp $ORIGINDIR/linux_files/yum.conf $BUILDDIR/etc/yum.conf
#sudo cp $ORIGINDIR/linux_files/wslu.yum.conf $BUILDDIR/etc/yum.conf.d/wslu.yum.conf

sudo bash -c "echo 'export DISPLAY=:0' >> $BUILDDIR/etc/profile"
sudo bash -c "echo 'export LIBGL_ALWAYS_INDIRECT=1' >> $BUILDDIR/etc/profile"
sudo bash -c "echo 'export NO_AT_BRIDGE=1' >> $BUILDDIR/etc/profile"

tar --ignore-failed-read --numeric-owner -czvf install.tar.gz $BUILDDIR/*

sudo rm /tmp/boot7.iso