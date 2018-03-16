#!/bin/bash

PROFILEDIR=$(mktemp -p /tmp -d tmp-fx-profile.XXXXXX.d)
chromium-browser --user-data-dir=$PROFILEDIR --no-default-browser-check --no-first-run
rm -rf $PROFILEDIR
