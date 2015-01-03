#!/bin/bash

shopt -s expand_aliases
alias rsync="rsync -a --progress --exclude '*~'"
alias drsync="rsync --delete"

declare -A rsync_folders
declare -A drsync_folders

# rsync
## Videos
rsync_folders["/run/media/jenselme/Data/Videos/"]="/run/media/jenselme/Backup_Data/Videos"


# drsync
## VM
drsync_folders["/run/media/jenselme/Data/VM/"]="/run/media/jenselme/Backup_Data/VM"
## Pictures
drsync_folders["/home/jenselme/Pictures/"]="/run/media/jenselme/Backup_Data/Pictures"
## Music
drsync_folders["/home/jenselme/Music/"]="/run/media/jenselme/Backup_Data/Music"
## Archives
drsync_folders["/run/media/jenselme/Data/Archives/"]="/run/media/jenselme/Backup_Data/Archives"
## Downloads
drsync_folders["/home/jenselme/Downloads/"]="/run/media/jenselme/Backup_Data/Downloads"
## Android
drsync_folders["/home/jenselme/android/"]="/run/media/jenselme/Backup_Data/android"
## Books
drsync_folders["/home/jenselme/Livres/"]="/run/media/jenselme/Backup_Data/Livres"

for folder in "${!rsync_folders[@]}"; do
    echo -e "${folder}"
    rsync "${folder}" "${rsync_folders[$folder]}"
done

for folder in "${!drsync_folders[@]}"; do
    echo -e "${folder}"
    drsync "${folder}" "${drsync_folders[$folder]}"
done

