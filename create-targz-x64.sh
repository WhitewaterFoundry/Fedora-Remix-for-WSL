set -e

target=$(mktemp -d --tmpdir)

set -x

mkdir -m 755 "$target"/dev
sudo mknod -m 600 "$target"/dev/console c 5 1
sudo mknod -m 600 "$target"/dev/initctl p
sudo mknod -m 666 "$target"/dev/full c 1 7
sudo mknod -m 666 "$target"/dev/null c 1 3
sudo mknod -m 666 "$target"/dev/ptmx c 5 2
sudo mknod -m 666 "$target"/dev/random c 1 8
sudo mknod -m 666 "$target"/dev/tty c 5 0
sudo mknod -m 666 "$target"/dev/tty0 c 4 0
sudo mknod -m 666 "$target"/dev/urandom c 1 9
sudo mknod -m 666 "$target"/dev/zero c 1 5

sudo yum --installroot="$target" --releasever=/ groupinstall "Core" --exclude=kernel*,plymouth,*-firmware,microcode_ctl

sudo yum --installroot="$target" --releasever=/ install git curl sudo 

sudo yum --installroot="$target" -y clean all

cat > network <<EOF
NETWORKING=yes
#HOSTNAME=localhost.localdomain
EOF
sudo cp network "$target"/etc/sysconfig/network

sudo rm -rf "$target"/var/cache/yum
sudo mkdir -p --mode=0755 "$target"/var/cache/yum

sudo rm -rf "$target"/etc/ld.so.cache "$target"/var/cache/ldconfig
sudo mkdir -p --mode=0755 "$target"/var/cache/ldconfig

sudo cp ./linux_files/wsl.conf "$target"/etc/wsl.conf
#sudo cp ./linux_files/yum.conf "$target"/etc/yum.conf
#sudo cp ./linux_files/wslu.yum.conf "$target"/etc/yum.conf.d/wslu.yum.conf

sudo bash -c "echo 'export DISPLAY=:0' >> $target/etc/profile"
sudo bash -c "echo 'export LIBGL_ALWAYS_INDIRECT=1' >> $target/etc/profile"
sudo bash -c "echo 'export NO_AT_BRIDGE=1' >> $target/etc/profile"

tar --ignore-failed-read --numeric-owner -czvf install.tar.gz $target/*
