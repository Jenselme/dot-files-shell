#!/usr/bin/env bash

! rpmbuild -bp "$1" && echo "rpmbuild -bp $1 && failed." >&2; exit 1;
! rpmbuild -bc --short-circuit "$1" || echo "rpmbuild -bc --short-circuit $1 && failed" >&2; exit 2;
! rpmbuild -bi --short-circuit "$1" || echo "rpmbuild -bi --short-circuit $1" >&2; exit 3;
! rpmbuild -ba "$1" || echo "rpmbuild -ba $1 && failed." >&2; exit 4;
