#!/usr/bin/env bash

shopt -s expand_aliases
alias rsync="rsync -a --progress --exclude '*~'"
alias drsync="rsync --delete"

declare -A rsync_folders
declare -A drsync_folders


# drsync
## VM
drsync_folders["/run/media/jenselme/Data/VM/"]="/run/media/jenselme/Backup_2TB/VM"
## Android
drsync_folders["/run/media/jenselme/Data/android-sdk-linux/"]="/run/media/jenselme/Backup_2TB/android-sdk-linux"
## Projects data
drsync_folders["/run/media/jenselme/Data/projects-data/"]="/run/media/jenselme/Backup_2TB/projects-data"
## Music
drsync_folders["/home/jenselme/Music/"]="/run/media/jenselme/Backup_2TB/Music"
## Archives
drsync_folders["/run/media/jenselme/Data/Archives/"]="/run/media/jenselme/Backup_2TB/Archives"
## Downloads
drsync_folders["/home/jenselme/Downloads/"]="/run/media/jenselme/Backup_2TB/Downloads"
## Books
drsync_folders["/home/jenselme/Livres/"]="/run/media/jenselme/Backup_2TB/Livres"
## Projects
drsync_folders["/home/jenselme/Projects/"]="/run/media/jenselme/Backup_2TB/projects"
## tests
drsync_folders["/home/jenselme/tests/"]="/run/media/jenselme/Backup_2TB/tests"
## Work
drsync_folders["/home/jenselme/Work/"]="/run/media/jenselme/Backup_2TB/Work"
## Fedora
drsync_folders["/home/jenselme/fedora-scm/"]="/run/media/jenselme/Backup_2TB/fedora-scm"

for folder in "${!rsync_folders[@]}"; do
    echo -e "${folder}"
    rsync "${folder}" "${rsync_folders[$folder]}"
done

for folder in "${!drsync_folders[@]}"; do
    echo -e "${folder}"
    drsync "${folder}" "${drsync_folders[$folder]}"
done
