#!/usr/bin/env bash
# script d'installation des logiciels

########               ajout des dépots
# free
yum install -y --nogpgcheck http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
# remi
yum install -y http://rpms.famillecollet.com/remi-release-20.rpm 2>> install.log


######                 mise à jour
yum update -y 2>> install.log


######			bureautique
yum install -y evince gedit pdfchain homebank mirall 2>> install.log
yum install -y libreoffice libreoffice-langpack-fr libreoffice-langpack-en libreoffice-langpack-de 2>> install.log



####			extensions gnome
yum install -y gnome-shell-extension-common gnome-tweak-tool dconf-editor gnome-shell-extension-gpaste 2>> install.log


#####			LaTeX
# TeXlive
yum install -y texlive-scheme-full 2>> install.log
# LaTeX IDE
yum install -y latexila 2>> install.log



######			graphisme
yum install -y inkscape scribus dia gimp 2>> install.log



######			Internet
yum install -y thunderbird epiphany cclive midori qupzilla youtube-dl liferea transmission 2>> install.log



######			multimédia
# Codec
yum install -y gstreamer-ffmpeg gstreamer-plugins-bad gstreamer-plugins-ugly 2>> install.log
# lecteurs
yum install -y vlc Miro smplayer rhythmbox totem 2>> install.log
# DVD
yum install -y libdvdcss --enablerepo=remi 2>> install.log



######			jeux
yum install -y wesnoth 2>> install.log

yum install -y nautilus-image-converter nautilus-open-terminal

######			divers
yum install -y nautilus-image-converter nautilus-open-terminal 2>> install.log
yum install -y xz-lzma-compat empathy system-config-services 2>> install.log
yum install -y gnome-password-generator 2>> install.log
yum install -y zsh deja-dup 2>> install.log



#####			éducation
#yum install -y wxMaxima 2>> install.log
# Math
yum install -y scilab scilab-doc 2>> install.log



####			programmation, dével
# divers
yum install -y meld geany git gitk git-cola unar mercurial vim 2>> install.log
# Virtualisation
yum install -y VirtualBox virt-manager libvirt libvirt-daemon-kvm qemu-system-arm qemu-user
# mysql
yum install -y mariadb-server 2>> install.log
# php
yum install -y php php-mysql php-gd php-drush-drush php-fpm  2>> install.log
# HTTP
yum install -y httpd nginx 2>> install.log
# C/C++
yum install -y codeblocks gcc gcc-c++ gcc-objc++ cmake clang 2>> install.log
# D
yum install ldc ldc-druntime ldc-druntime-devel ldc-phobos\* ldc-phobos-geany-tags
# Java
yum install -y eclipse java-*-openjdk java-*-openjdk-javadoc java-*-openjdk-devel 2>> install.log
# Qt
yum install -y qt-creator PyQt4 PyQt4-devel qscintilla-python qscintilla-devel 2>> install.log
# python
yum install -y eric spyder ninja-ide python3-ipython
# Computer vision
#yum install -y simplecv
# Docker
yum install -y docker docker-compose



###			Électronique
yum -y install arduino ino 2>> install.log


###         Autonomie
yum -y install powertop tuned 2>> install.log



###			 emacs
# pour LaTeX dans emacs
yum install -y emacs aspell aspell-fr aspell-de aspell-en 2>> install.log
# autre
yum install -y emacs-pymacs #python-jedi



####			XFCE
yum install -y fluxbox 2>> install.log
