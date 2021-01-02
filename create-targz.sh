#!/bin/bash

# Set environment
set -e
ORIGINDIR=$(pwd)
TMPDIR=$(mktemp -d -p "${HOME}")
ARCH=""
ARCHDIR=""

function build() {
  # Install dependencies
  dnf -y update
  dnf -y install mock
  if [ "$(uname -i)" != "$ARCH" ]; then
    dnf -y install qemu-user-static
    systemctl restart systemd-binfmt.service
  fi

  # Move to our temporary directory
  cd "$TMPDIR"
  mkdir "$TMPDIR"/dist

  # Make sure /dev is created before later mount
  mkdir -m 0755 "$TMPDIR"/dist/dev

  # Use mock to initialise chroot filesystem
  mock --init --dnf --forcearch=$ARCH --rootdir="$TMPDIR"/dist

  # Bind mount current /dev to new chroot/dev
  # (fixes '/dev/null: Permission denied' errors)
  mount --bind /dev "$TMPDIR"/dist/dev

  # Install required packages, exclude unnecessary packages to reduce image size
  dnf --installroot="$TMPDIR"/dist --forcearch=$ARCH -y install @core libgcc glibc-langpack-en --exclude=grub\*,sssd-kcm,sssd-common,sssd-client,linux-firmware,dracut*,plymouth,parted,e2fsprogs,iprutils,iptables,ppc64-utils,selinux-policy*,policycoreutils,sendmail,kernel*,firewalld,fedora-release,fedora-logos,fedora-release-notes --allowerasing

  # Unmount /dev
  umount "$TMPDIR"/dist/dev

  mkdir -p "$TMPDIR"/dist/etc/fonts/
  mkdir -p "$TMPDIR"/dist/usr/local/bin/
  
  # Fix dnf.conf
  # shellcheck disable=SC2155
  local from_index=$(grep -n -m 1 '\[main\]' "$TMPDIR"/dist/etc/dnf/dnf.conf | cut -d : -f 1)
  # shellcheck disable=SC2155
  local to_index=$(grep -n -m 1 '# repos' "$TMPDIR"/dist/etc/dnf/dnf.conf | cut -d : -f 1)
  sed -i "${from_index}"','"$((to_index - 2))"'d' "$TMPDIR"/dist/etc/dnf/dnf.conf

  cat "$ORIGINDIR"/linux_files/dnf.conf "$TMPDIR"/dist/etc/dnf/dnf.conf>"$TMPDIR"/dist/etc/dnf/dnf.temp
  mv "$TMPDIR"/dist/etc/dnf/dnf.temp "$TMPDIR"/dist/etc/dnf/dnf.conf
     
  # Copy over some of our custom files
  cp "$ORIGINDIR"/linux_files/wsl.conf "$TMPDIR"/dist/etc/
  cp "$ORIGINDIR"/linux_files/local.conf "$TMPDIR"/dist/etc/fonts/
  cp "$ORIGINDIR"/linux_files/00-remix.sh "$TMPDIR"/dist/etc/profile.d/
  chmod -x "$TMPDIR"/dist/etc/profile.d/00-remix.sh
  
  cp "$ORIGINDIR"/linux_files/upgrade.sh "$TMPDIR"/dist/usr/local/bin/
  chmod +x "$TMPDIR"/dist/usr/local/bin/upgrade.sh

  # Comply with Fedora Remix terms
  systemd-nspawn -q -D "$TMPDIR"/dist --pipe /bin/bash <<EOF
dnf -y update
dnf -y install generic-release --allowerasing
EOF

  # Overwrite os-release provided by generic-release
  cp "$ORIGINDIR"/linux_files/os-release "$TMPDIR"/dist/etc/os-release

  # Install cracklibs-dicts
  systemd-nspawn -q -D "$TMPDIR"/dist --pipe /bin/bash <<EOF
dnf -y install --allowerasing --skip-broken cracklib-dicts
EOF

  # Install bash-completion, vim, wget
  systemd-nspawn -q -D "$TMPDIR"/dist --pipe /bin/bash <<EOF
dnf -y install bash-completion vim wget distribution-gpg-keys

echo 'source /etc/vimrc' > /etc/skel/.vimrc
echo 'set background=dark' >> /etc/skel/.vimrc
echo 'set visualbell' >> /etc/skel/.vimrc
echo 'set noerrorbells' >> /etc/skel/.vimrc

echo '\$include /etc/inputrc' > /etc/skel/.inputrc
echo 'set bell-style none' >> /etc/skel/.inputrc
echo 'set show-all-if-ambiguous on' >> /etc/skel/.inputrc
echo 'set show-all-if-unmodified on' >> /etc/skel/.inputrc
EOF

  # Fix ping
  systemd-nspawn -q -D "$TMPDIR"/dist --pipe /bin/bash <<EOF
chmod u+s "$(command -v ping)"
EOF

  # Reinstall crypto-policies and clean up
  systemd-nspawn -q -D "$TMPDIR"/dist --pipe /bin/bash <<EOF
dnf -y reinstall crypto-policies --exclude=grub\*,dracut*,grubby,kpartx,kmod,os-prober,libkcapi*
dnf -y autoremove
dnf -y clean all
EOF

  # 'Setup WSLU
  systemd-nspawn -q -D "$TMPDIR"/dist --pipe /bin/bash <<EOF
(
  source /etc/os-release && dnf -y copr enable wslutilities/wslu "\${ID_LIKE}-\${VERSION_ID}-${ARCH}"
)
dnf -y install wslu
EOF

  # Create filesystem tar, excluding unnecessary files
  cd "$TMPDIR"/dist
  tar --exclude='boot/*' --exclude=proc --exclude=dev --exclude=sys --exclude='var/cache/dnf/*' --numeric-owner -czf "$ORIGINDIR"/$ARCHDIR/install.tar.gz ./*

  # Return to origin directory
  cd "$ORIGINDIR"

  # Cleanup
  rm -rf "$TMPDIR"
}

function usage() {
  echo "./create-targz.sh <BUILD_ARCHITECTURE>"
  echo "Possible architectures: arm64, x86_64"
}

# Accept argument input for architecture type
ARCH="$1"
if [ "$ARCH" = "x86_64" ]; then
  ARCH="x86_64"
  ARCHDIR="x64"
  build
elif [ "$ARCH" = "arm64" ]; then
  ARCH="aarch64"
  ARCHDIR="ARM64"
  build
else
  usage
fi
