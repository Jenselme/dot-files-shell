#!/usr/bin/bash

if [ -z "$1"  ] ; then
    echo "Not enough arguments. Pattern is required."
    echo "cmd pattern [patchname]"
    exit 1
fi

if [ -z "$2" ] ; then
    patchname="$2"
else
    patchname="$1.patch"
fi

for filename in $(grep -lri "$1" *); do
    cp "${filename}" "${filename}.bak"
    sed -i "/$1/d" "${filename}"
    diff -u "${filename}.bak" "${filename}" >> "${patchname}"
done
