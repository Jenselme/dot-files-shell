#!/usr/bin/env bash

shopt -s expand_aliases
alias rsync="rsync -a --progress --exclude '*~'"
alias drsync="rsync --delete"

declare -A rsync_folders
declare -A drsync_folders

# rsync
## Pictures
rsync_folders["/home/jenselme/Pictures/"]="/run/media/jenselme/Backup_2TB/Pictures"


# drsync
## Videos
drsync_folders["/run/media/jenselme/Multimedia/Videos/"]="/run/media/jenselme/Backup_2TB/Videos"
## Jeux Vidéos
drsync_folders["/run/media/jenselme/Multimedia/Jeux Videos/"]="/run/media/jenselme/Backup_2TB/Jeux Videos"
## VM
drsync_folders["/run/media/jenselme/Data/VM/"]="/run/media/jenselme/Backup_2TB/VM"
## Music
drsync_folders["/home/jenselme/Music/"]="/run/media/jenselme/Backup_2TB/Music"
## Archives
drsync_folders["/run/media/jenselme/Data/Archives/"]="/run/media/jenselme/Backup_2TB/Archives"
## Downloads
drsync_folders["/home/jenselme/Downloads/"]="/run/media/jenselme/Backup_2TB/Downloads"
## Books
drsync_folders["/home/jenselme/Livres/"]="/run/media/jenselme/Backup_2TB/Livres"

for folder in "${!rsync_folders[@]}"; do
    echo -e "${folder}"
    rsync "${folder}" "${rsync_folders[$folder]}"
done

for folder in "${!drsync_folders[@]}"; do
    echo -e "${folder}"
    drsync "${folder}" "${drsync_folders[$folder]}"
done
