set -e

target=$(mktemp -d --tmpdir)
yum_config=/etc/yum.conf

set -x

mkdir -m 755 "$target"/dev
mknod -m 600 "$target"/dev/console c 5 1
mknod -m 600 "$target"/dev/initctl p
mknod -m 666 "$target"/dev/full c 1 7
mknod -m 666 "$target"/dev/null c 1 3
mknod -m 666 "$target"/dev/ptmx c 5 2
mknod -m 666 "$target"/dev/random c 1 8
mknod -m 666 "$target"/dev/tty c 5 0
mknod -m 666 "$target"/dev/tty0 c 4 0
mknod -m 666 "$target"/dev/urandom c 1 9
mknod -m 666 "$target"/dev/zero c 1 5

yum -c "$yum_config" --installroot="$target" --releasever=/ --setopt=tsflags=nodocs --setopt=group_package_types=mandatory -y groupinstall "Core"

yum -c "$yum_config" --installroot="$target" --releasever=/ --setopt=tsflags=nodocs --setopt=group_package_types=mandatory -y install "git curl python3"

yum -c "$yum_config" --installroot="$target" -y clean all

cat > "$target"/etc/sysconfig/network <<EOF
NETWORKING=yes
HOSTNAME=localhost.localdomain
EOF

rm -rf "$target"/var/cache/yum
mkdir -p --mode=0755 "$target"/var/cache/yum

rm -rf "$target"/etc/ld.so.cache "$target"/var/cache/ldconfig
mkdir -p --mode=0755 "$target"/var/cache/ldconfig

tar --ignore-failed-read --numeric-owner -czvf $TMPDIR/install.tar.gz *