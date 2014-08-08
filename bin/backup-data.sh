#!/bin/bash

shopt -s expand_aliases
alias rsync="rsync -a --progress --exclude '*~'"
alias drsync="rsync --delete"

echo -e "Vidéos\n"
rsync /run/media/jenselme/Data/Videos/ /run/media/jenselme/Backup_Data/Videos

echo -e "VM\n"
drsync /run/media/jenselme/Data/VM/ /run/media/jenselme/Backup_Data/VM

echo -e "Pictures\n"
drsync /home/jenselme/Pictures/ /run/media/jenselme/Backup_Data/Pictures

echo -e "Music\n"
drsync /home/jenselme/Music/ /run/media/jenselme/Backup_Data/Music

echo -e "Archives\n"
drsync /run/media/jenselme/Data/Archives/ /run/media/jenselme/Backup_Data/Archives

echo -e "Downloads"
drsync /home/jenselme/Downloads/ /run/media/jenselme/Backup_Data/Downloads
