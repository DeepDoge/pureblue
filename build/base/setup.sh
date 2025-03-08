#!/bin/bash

cd "$(dirname "$0")"

echo "Setup Base"
set -x

rsync -av ./usr/ /usr/
rsync -av ./etc/ /etc/

FEDORA_VERSION=$(rpm -E %fedora)

#./yum.sh MAKE THIS WORK IF YOU CAN. WE WANT TO KEEP /etc CLEAN

rpm-ostree install --apply-live \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${FEDORA_VERSION}.noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${FEDORA_VERSION}.noarch.rpm

rpm-ostree install \
    rpmfusion-free-release \
    rpmfusion-nonfree-release \
    --uninstall \
    rpmfusion-free-release-${FEDORA_VERSION}-* \
    rpmfusion-nonfree-release-${FEDORA_VERSION}-*

rpm-ostree override remove firefox firefox-langpacks
rpm-ostree install --idempotent  gnome-tweaks openssl
rpm-ostree cleanup -m

systemctl enable pureblue.service