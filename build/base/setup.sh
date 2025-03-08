#!/bin/bash

cd "$(dirname "$0")"

echo "Setup Base"

rsync -av ./etc/ /etc/
rsync -av ./usr/ /usr/

rpm-ostree override remove firefox firefox-langpacks
rpm-ostree install gnome-tweaks openssl
rpm-ostree cleanup -m

systemctl enable pureblue.service

# I wonder if this atleast caches the installs
flatpak remote-add --system --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install --system -y \
    it.mijorus.gearlever \
    com.usebottles.bottles \
    io.podman_desktop.PodmanDesktop \
    com.github.rafostar.Clapper \
    io.bassi.Amberol \
    io.missioncenter.MissionCenter \
    com.mattjakeman.ExtensionManager
