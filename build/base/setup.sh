#!/bin/bash

rsync -av ./etc/ /etc/

rpm-ostree override remove firefox firefox-langpacks
rpm-ostree install gnome-tweaks openssl
rpm-ostree cleanup -m

systemctl enable pureblue-startup.service