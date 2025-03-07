#!/bin/bash

# Fail on any issue
set -euxo pipefail

# RPM Layered packages
rpm-ostree override remove firefox firefox-langpacks
rpm-ostree install gnome-tweaks openssl
rpm-ostree cleanup -m

flatpak remote-add --system --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

flatpak install -y \
    it.mijorus.gearlever \
    com.usebottles.bottles \
    io.podman_desktop.PodmanDesktop \
    org.gnome.Music \
    io.github.celluloid_player.Celluloid

# Install Homebrew
mkdir /homebrew && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip-components 1 -C /homebrew

# Add `brew` to PATH, system-wide
echo 'export PATH="/homebrew/bin:$PATH"' > /etc/profile.d/homebrew.sh && \
    chmod +x /etc/profile.d/homebrew.sh