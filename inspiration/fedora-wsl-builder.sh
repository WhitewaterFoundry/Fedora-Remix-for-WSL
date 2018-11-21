#!/bin/bash

RELEASEVER=26
PACKAGES="bash dnf man passwd shadow-utils sudo vim-minimal iproute iputils bind-utils tar openssh-server procps-ng"

set -euo pipefail
set -x

INSTALLROOT="$(mktemp -d)"
dnf -y --installroot "${INSTALLROOT}" --releasever "${RELEASEVER}" install ${PACKAGES}
pushd "${INSTALLROOT}"
rm -rf var/cache/yum/*
rm -f etc/machine-id
touch etc/machine-id
tar -cf - * | gzip > "${HOME}/fedora-${RELEASEVER}-wsl.tar.gz"
popd
rm -rf "${INSTALLROOT}"