#!/bin/bash

PROFILEDIR=$(mktemp -p /tmp -d tmp-fx-profile.XXXXXX.d)
firefox -profile $PROFILEDIR -no-remote -new-instance
rm -rf $PROFILEDIR
