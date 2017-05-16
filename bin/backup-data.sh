#!/usr/bin/env bash

shopt -s expand_aliases
alias rsync="rsync -a --progress --exclude '*~'"
alias drsync="rsync --delete"

declare -A rsync_folders
declare -A drsync_folders


# drsync
## Projects data
drsync_folders["/run/media/jenselme/Data/projects-data/"]="/run/media/jenselme/Backup_2TB/projects-data"
## Books
drsync_folders["/home/jenselme/Livres/"]="/run/media/jenselme/Backup_2TB/Livres"
## tests
drsync_folders["/home/jenselme/tests/"]="/run/media/jenselme/Backup_2TB/tests"

# Compture specific
case $(hostname -s) in
    baley)
        drsync_folders["/mnt/data/jenselme/VM/"]="/run/media/jenselme/Backup_2TB/VM_Baley"
        drsync_folders["/mnt/data/jenselme/Jeux Videos/"]="/run/media/jenselme/Backup_2TB/Jeux Videos"
        drsync_folders["/mnt/data/jenselme/Archives/"]="/run/media/jenselme/Backup_2TB/Archives"
        drsync_folders["/home/jenselme/Downloads/"]="/run/media/jenselme/Backup_2TB/Downloads_Baley"
        drsync_folders["/home/jenselme/Projects/"]="/run/media/jenselme/Backup_2TB/Projects_Baley"
        drsync_folders["/home/jenselme/fedora-scm/"]="/run/media/jenselme/Backup_2TB/fedora-scm_Baley"
        ;;
    fastolfe)
        drsync_folders["/run/media/jenselme/Data/VM/"]="/run/media/jenselme/Backup_2TB/VM"
        drsync_folders["/home/jenselme/Downloads/"]="/run/media/jenselme/Backup_2TB/Downloads_Fastolfe"
        drsync_folders["/home/jenselme/Projects/"]="/run/media/jenselme/Backup_2TB/Projects_Fastolfe"
        drsync_folders["/home/jenselme/fedora-scm/"]="/run/media/jenselme/Backup_2TB/fedora-scm_Fastolfe"
        ;;
esac


for folder in "${!rsync_folders[@]}"; do
    echo -e "${folder}"
    rsync "${folder}" "${rsync_folders[$folder]}"
done

for folder in "${!drsync_folders[@]}"; do
    echo -e "${folder}"
    drsync "${folder}" "${drsync_folders[$folder]}"
done
