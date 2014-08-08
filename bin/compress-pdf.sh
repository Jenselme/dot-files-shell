#!/usr/bin/env bash

gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile="$1-out" "$1"
