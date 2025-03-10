#!/bin/bash

cd "$(dirname "$0")"

echo "Setup NVIDIA"
set -x
set -euxo pipefail

FEDORA_VERSION=$(rpm -E %fedora)

# Add lukenukem's repo for supergfxctl
wget https://copr.fedorainfracloud.org/coprs/lukenukem/asus-linux/repo/fedora-${FEDORA_VERSION}/lukenukem-asus-linux-fedora-${FEDORA_VERSION}.repo -O /etc/yum.repos.d/_copr_lukenukem-asus-linux.repo

# These should be more than enough.
rpm-ostree install akmod-nvidia xorg-x11-drv-nvidia{,-cuda} supergfxctl
