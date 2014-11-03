#!/usr/bin/bash

PATH=/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/sbin:/home/jenselme/bin:/home/jenselme/android/android-sdk-linux/tools:/home/jenselme/android/android-ndk-r10c:/home/jenselme/IDE/netbeans/netbeans-8.0/bin:/home/jenselme/IDE/idea-IU-135.1289/bin/
export PATH

# NDK config (for android native apps)
NDK_PATH=/home/jenselme/android/android-ndk-r10c
NDKROOT=$NDK_PATH
export NDK_PATH NDKROOT

# NPM
NPM_PACKAGES="$HOME/.npm-packages"
PATH="$NPM_PACKAGES/bin:$PATH"
unset MANPATH
MANPATH="$NPM_PACKAGES/share/man:$(manpath)"
NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"
export NPM_PACKAGES PATH MANPATH NODE_PATH
