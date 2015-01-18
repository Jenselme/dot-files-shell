#!/usr/bin/env bash

DEST='/home/jenselme/Data/Archives/Scolarite/ECM/sas/'
SOURCE1='jenselme:~/Documents'
SOURCE2='jenselme:~/workspace'
SOURCE3='jenselme:~/private'
SOURCE4='jenselme:~/html'

rsync -rltpP --exclude *.mat --delete "${SOURCE1}" "${DEST}"
rsync -rltpP --delete "${SOURCE2}" "${DEST}"
rsync -rltpP --delete --exclude clubdrupal "${SOURCE3}" "${DEST}"
rsync -rltpP --exclude *.src.rpm --delete "${SOURCE4}" "${DEST}"
