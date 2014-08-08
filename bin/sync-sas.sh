#!/usr/bin/env bash

DEST='/home/jenselme/Data/Archives/Scolarite/ECM/sas/'
SOURCE1='jenselme:~/Documents/'
SOURCE2='jenselme:~/workspace'

rsync -rltpP --exclude *.mat --delete $SOURCE1 $DEST/Documents/
rsync -rltpP --delete $SOURCE2 $DEST
