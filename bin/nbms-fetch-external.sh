#!/usr/bin/env bash

set -e
set -u

if [[ ! -d contrib ]]; then
    echo 'This must be launched at the root of the NetBeans directory' >&2
    exit 1
fi


echo 'Fetching pep8.py'
cd contrib/python.pep8/external
wget https://dl.jujens.eu/nbms/pep8.py

cd -
echo 'Fetching jedi.zip'
cd contrib/python.jedi/external
wget https://dl.jujens.eu/nbms/jedi.zip

cd -
echo 'Fetching pyflakes.zip'
cd contrib/python.pyflakes/external
wget https://dl.jujens.eu/nbms/pyflakes.zip

