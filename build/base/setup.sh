#!/bin/bash

cd "$(dirname "$0")"

echo "Setup Base"
set -x
set -euxo pipefail

FEDORA_VERSION=$(rpm -E %fedora)

rsync -av ./usr/ /usr/

# Add lukenukem's repo for supergfxctl
wget https://copr.fedorainfracloud.org/coprs/lukenukem/asus-linux/repo/fedora-${FEDORA_VERSION}/lukenukem-asus-linux-fedora-${FEDORA_VERSION}.repo -O /etc/yum.repos.d/_copr_lukenukem-asus-linux.repo

rpm-ostree override remove firefox firefox-langpacks
rpm-ostree install --idempotent gnome-tweaks openssl supergfxctl

systemctl enable pureblue.service