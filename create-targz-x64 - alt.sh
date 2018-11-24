set -e

sudo yum install libvirt lorax virt-install libvirt-daemon-config-network libvirt-daemon-kvm libvirt-daemon-driver-qemu
sudo systemctl restart libvirtd

curl http://mirror.centos.org/centos/7/os/x86_64/images/boot.iso -o /tmp/boot7.iso

# clone and edit this kickstart file, if this approach works
curl https://raw.githubusercontent.com/CentOS/sig-cloud-instance-build/master/docker/centos-7.ks -o centos-7.ks
# other option: https://github.com/CentOS/sig-cloud-instance-build/blob/master/cloudimg/CentOS-7-x86_64-GenericCloud-201606-r1.ks

sudo livemedia-creator --make-tar --iso=/tmp/boot7.iso --image-name=install.tar.gz --compression=gzip --ks=centos-7.ks