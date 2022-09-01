#!/usr/bin/env bash

echo 'Updating pipx packages'
pipx upgrade-all
echo 'Updating flatpak packages'
sudo flatpak update --assumeyes
echo 'Updating distro'
sudo zypper dup --auto-agree-with-licenses --no-allow-vendor-change --replacefiles
