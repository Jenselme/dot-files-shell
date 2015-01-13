#!/usr/bin/env bash

source ~/.functions

rpmbuild -bp "$1" || error_exit "rpmbuild -bp $1 && failed." 1
rpmbuild -bc --short-circuit "$1" || error_exit "rpmbuild -bc --short-circuit $1 && failed" 2
rpmbuild -bi --short-circuit "$1" || error_exit "rpmbuild -bi --short-circuit $1" 3
rpmbuild -ba "$1" || error_exit "rpmbuild -ba $1 && failed." 4
