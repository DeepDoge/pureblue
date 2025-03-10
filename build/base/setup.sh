#!/bin/bash

cd "$(dirname "$0")"

echo "Setup Base"
set -x
set -euxo pipefail

rsync -av ./usr/ /usr/

rpm-ostree install --apply-live \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${FEDORA_VERSION}.noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${FEDORA_VERSION}.noarch.rpm

rpm-ostree install --apply-live \
    rpmfusion-free-release \
    rpmfusion-nonfree-release \
    --uninstall \
    rpmfusion-free-release-${FEDORA_VERSION}-* \
    rpmfusion-nonfree-release-${FEDORA_VERSION}-*

rpm-ostree override remove firefox firefox-langpacks
rpm-ostree install --idempotent gnome-tweaks openssl
rpm-ostree cleanup -m

systemctl enable pureblue.service