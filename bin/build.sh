#!/usr/bin/env bash

rpmbuild -bp "$1"

if (( ! $? )) ; then
  rpmbuild -bc --short-circuit "$1"
else
  echo "rpmbuild -bp $1 && failed."
  exit 1
fi

if (( ! $? )) ; then
  rpmbuild -bi --short-circuit "$1"
else
  echo "rpmbuild -bc --short-circuit $1 && failed"
  exit 1
fi

ret="$?"
if (( ! $? )) ; then
  rpmbuild -ba "$1"
else
  echo "rpmbuild -bi --short-circuit $1"
  exit 1
fi

ret="$?"
if (( $? )) ; then
  echo "rpmbuild -ba $1 && failed."
  exit 1
else
  exit 0
fi
