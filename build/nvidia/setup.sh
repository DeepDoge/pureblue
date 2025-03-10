#!/bin/bash

cd "$(dirname "$0")"

echo "Setup NVIDIA"
set -x
set -euxo pipefail

# Add lukenukem's repo for supergfxctl
wget https://copr.fedorainfracloud.org/coprs/lukenukem/asus-linux/repo/fedora-$(rpm -E %fedora)/lukenukem-asus-linux-fedora-$(rpm -E %fedora).repo -O /etc/yum.repos.d/_copr_lukenukem-asus-linux.repo

# These should be more than enough.
rpm-ostree install --idempotent kmod-nvidia xorg-x11-drv-nvidia{,-cuda} supergfxctl

# TODO: Ok this wont run at build time, find out what to do instead.
# rpm-ostree kargs \
#     --append-if-missing=rd.driver.blacklist=nouveau \
#     --append-if-missing=modprobe.blacklist=nouveau \
#     --append-if-missing=nvidia-drm.modeset=1