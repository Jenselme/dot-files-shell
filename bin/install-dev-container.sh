#!/usr/bin/env bash

set -eu

sudo apt update
sudo apt install -y zsh most curl wget direnv git

sudo curl -sS https://starship.rs/install.sh | sh -s -- --yes
wget https://github.com/dandavison/delta/releases/download/0.16.5/git-delta_0.16.5_amd64.deb
sudo dpkg -i git-delta_0.16.5_amd64.deb
rm -rf delta-0.16.5-i686-unknown-linux-gnu

git submodule update --init .oh-my-zsh/
git submodule update --init .oh-my-zsh-custom/

PROJECT_DIR="$(dirname "$(dirname "$(realpath "$0")")")"
cp -r $PROJECT_DIR/. ~/

sudo chsh -s $(which zsh) $(whoami)
