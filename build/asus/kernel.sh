#!/bin/bash

cd "$(dirname "$0")"

echo "Setup Asus Kernel"
set -x
set -euxo pipefail

wget https://copr.fedorainfracloud.org/coprs/lukenukem/asus-linux/repo/fedora-$(rpm -E %fedora)/lukenukem-asus-linux-fedora-$(rpm -E %fedora).repo -O /etc/yum.repos.d/_copr_lukenukem-asus-linux.repo 
wget https://copr.fedorainfracloud.org/coprs/lukenukem/asus-kernel/repo/fedora-$(rpm -E %fedora)/lukenukem-asus-kernel-fedora-$(rpm -E %fedora).repo -O /etc/yum.repos.d/_copr_lukenukem-asus-kernel.repo 

rpm-ostree cliwrap install-to-root / 
rpm-ostree override replace \
    --experimental \
    --from repo=copr:copr.fedorainfracloud.org:lukenukem:asus-kernel \
        kernel \
        kernel-core \
        kernel-modules \
        kernel-modules-core \
        kernel-modules-extra 