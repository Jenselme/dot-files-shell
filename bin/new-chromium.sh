#!/bin/bash

PROFILEDIR=$(mktemp -p /tmp -d tmp-fx-profile.XXXXXX.d)

if [[ -f /usr/bin/chromium ]]; then
    cmd=/usr/bin/chromium
else
    cmd=/usr/bin/chromium-browser
fi

"${cmd}" --user-data-dir=$PROFILEDIR --no-default-browser-check --no-first-run
rm -rf $PROFILEDIR
