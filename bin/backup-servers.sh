#!/usr/bin/bash

. /home/jenselme/bin/scripts-config.sh

# Backup giskard
rsync -rl --delete giskard:$rem_dir_giskard_backup/ $dir_giskard_backup
rsync -rl --delete giskard:$maildir_giskard $dir_giskard_backup
