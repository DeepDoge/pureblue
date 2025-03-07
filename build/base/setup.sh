#!/bin/bash

rsync -av ./etc/ /etc/
rsync -av ./usr/ /usr/

rpm-ostree override remove firefox firefox-langpacks
rpm-ostree install gnome-tweaks openssl
rpm-ostree cleanup -m

systemctl enable pureblue.service
