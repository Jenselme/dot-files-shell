#!/usr/bin/env bash

if [ -z "$1"  ] ; then
    echo "Not enough arguments. Pattern is required."
    echo "cmd pattern [patchname]"
    exit 1
fi

patchname="removed-pattern.patch"

for filename in $(grep -lri "$1" * | grep -v .bak); do
    cp "${filename}" "${filename}.bak"
    sed -i "/$1/d" "${filename}"
    diff -u "${filename}.bak" "${filename}" >> "${patchname}"
done

# Remove .bak in filenames of the patch
sed -i -e "s#^\(--- .*\)\.bak#\1#" "${patchname}"
