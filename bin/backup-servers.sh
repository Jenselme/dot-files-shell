#!/usr/bin/env bash

. /home/jenselme/bin/scripts-config.sh

rsync -a --delete --progress "olivaw:${remote_dir_daneel_backup}/" "${dir_daneel_backup}"
