#!/usr/bin/env bash

. /home/jenselme/bin/scripts-config.sh

# Backup giskard
rsync -a --delete "giskard:$rem_dir_giskard_backup/" "$dir_giskard_backup"
