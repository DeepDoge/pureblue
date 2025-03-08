#!/bin/bash

cd "$(dirname "$0")"

echo "Setup NVIDIA"
set -x

# These should be more than enough.
rpm-ostree install akmod-nvidia xorg-x11-drv-nvidia{,-cuda,-devel,-kmodsrc,-power,-libs} \
    nvidia-{container-toolkit,vaapi-driver} \
    supergfxctl

# Hope this wont be keep appending each time i rebase or update
rpm-ostree kargs --append=rd.driver.blacklist=nouveau --append=modprobe.blacklist=nouveau --append=nvidia-drm.modeset=1