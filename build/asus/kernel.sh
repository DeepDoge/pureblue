#!/bin/bash

cd "$(dirname "$0")"

echo "Setup Asus Kernel"
set -x
set -euxo pipefail

FEDORA_VERSION=$(rpm -E %fedora)

wget https://copr.fedorainfracloud.org/coprs/lukenukem/asus-linux/repo/fedora-${FEDORA_VERSION}/lukenukem-asus-linux-fedora-${FEDORA_VERSION}.repo -O /etc/yum.repos.d/_copr_lukenukem-asus-linux.repo 
wget https://copr.fedorainfracloud.org/coprs/lukenukem/asus-kernel/repo/fedora-${FEDORA_VERSION}/lukenukem-asus-kernel-fedora-${FEDORA_VERSION}.repo -O /etc/yum.repos.d/_copr_lukenukem-asus-kernel.repo 

rpm-ostree cliwrap install-to-root / 
rpm-ostree override replace \
    --experimental \
    --from repo=copr:copr.fedorainfracloud.org:lukenukem:asus-kernel \
        kernel \
        kernel-core \
        kernel-modules \
        kernel-modules-core \
        kernel-modules-extra 