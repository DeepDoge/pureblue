#!/bin/bash

cd "$(dirname "$0")"

echo "Setup Base"

rsync -av ./etc/ /etc/
rsync -av ./usr/ /usr/

rpm-ostree override remove firefox firefox-langpacks
rpm-ostree install gnome-tweaks openssl
rpm-ostree cleanup -m

systemctl enable pureblue.service
