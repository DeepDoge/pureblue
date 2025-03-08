#!/bin/bash

cd "$(dirname "$0")"

echo "Setup NVIDIA"
set -x
set -euxo pipefail

# These should be more than enough.
rpm-ostree install --idempotent akmod-nvidia xorg-x11-drv-nvidia{,-cuda,-devel,-kmodsrc,-power,-libs} \
    nvidia-{container-toolkit,vaapi-driver} \
    supergfxctl

# Hope this wont be keep appending each time i rebase or update
# TODO: Ok this wont run at build time, find out what to do instead.
# rpm-ostree kargs \
#     --append-if-missing=rd.driver.blacklist=nouveau \
#     --append-if-missing=modprobe.blacklist=nouveau \
#     --append-if-missing=nvidia-drm.modeset=1