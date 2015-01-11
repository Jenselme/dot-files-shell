#!/usr/bin/env bash

fswebcam -d /dev/video1 -r 960x720 --png 0 --no-banner --no-timestamp --no-title --save "$1"
