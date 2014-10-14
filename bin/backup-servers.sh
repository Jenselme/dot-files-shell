#!/usr/bin/bash

. /home/jenselme/bin/scripts-config.sh

# Backup giskard
rsync -rl --delete "giskard:$rem_dir_giskard_backup/" "$dir_giskard_backup"

## Dockuwiki (git)
cd /home/jenselme/server/dokuwiki
git pull > /dev/null 2>&1
