set -e

#declare variables
ORIGINDIR=$(pwd)
TMPDIR=$(mktemp -d)
BUILDDIR=$(mktemp -d)

#enterprise boot ISO
BOOTISO="http://ftp1.scientificlinux.org/linux/scientific/7x/x86_64/os/images/boot.iso"

#enterprise Docker kickstart file
KSFILE="https://raw.githubusercontent.com/CentOS/sig-cloud-instance-build/master/docker/centos-7.ks"

#upstream enterprise boot ISO
#BOOTISO="http://mirror.centos.org/centos/7.5.1804/os/x86_64/images/boot.iso"

#ARM64
#BOOTISO="http://vault.centos.org/altarch/7.3.1611/os/aarch64/images/boot.iso"
#KSFILE="https://raw.githubusercontent.com/CentOS/sig-cloud-instance-build/master/docker/centos-7arm64.ks"

#go to our temporary directory
cd $TMPDIR

#make sure we are up to date
sudo yum update

#get livemedia-creator dependencies
sudo yum install libvirt lorax virt-install libvirt-daemon-config-network libvirt-daemon-kvm libvirt-daemon-driver-qemu

#restart libvirtd for good measure
sudo systemctl restart libvirtd

#download enterprise boot ISO
sudo curl $BOOTISO -o /tmp/install.iso

#download enterprise Docker kickstart file
curl $KSFILE -o install.ks

#build intermediary rootfs tar
sudo livemedia-creator --make-tar --iso=/tmp/install.iso --image-name=install.tar.xz --ks=install.ks --releasever "7"

#open up the tar into our build directory
tar -xvf /var/tmp/install.tar.xz -C $BUILDDIR

#copy some custom files into our build directory 
sudo cp $ORIGINDIR/linux_files/wsl.conf $BUILDDIR/etc/wsl.conf
sudo cp $ORIGINDIR/linux_files/local.conf $BUILDDIR/etc/local.conf

#set some environmental variables in our build directory
sudo bash -c "echo 'export DISPLAY=:0' >> $BUILDDIR/etc/profile"
sudo bash -c "echo 'export LIBGL_ALWAYS_INDIRECT=1' >> $BUILDDIR/etc/profile"
sudo bash -c "echo 'export NO_AT_BRIDGE=1' >> $BUILDDIR/etc/profile"

#re-build our tar image
cd $BUILDDIR
tar --ignore-failed-read -czvf $ORIGINDIR/install.tar.gz *

#go home
cd $ORIGINDIR

#clean up
sudo rm -r $BUILDDIR
sudo rm -r $TMPDIR
sudo rm /tmp/install.iso
sudo rm /var/tmp/install.tar.xz
