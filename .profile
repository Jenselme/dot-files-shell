#!/usr/bin/bash

# Android
export ANDROID_HOME=/home/jenselme/Data/android-sdk-linux
export ANDROID_SDK="${ANDROID_HOME}"
#export ANDROID_NDK="/opt/software/android-ndk"
export ANDROID_PLATFORM_TOOLS="$ANDROID_SDK/platform-tools"

PATH=/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/sbin:/home/jenselme/bin:"${ANDROID_HOME}/tools":"${ANDROID_HOME}/platform-tools":~/.perl6/bin:~/.cargo/bin
export PATH

# NPM
NPM_PACKAGES="$HOME/.npm-packages"
PATH="$NPM_PACKAGES/bin:$PATH"
unset MANPATH
MANPATH="$NPM_PACKAGES/share/man:$(manpath)"
NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"
export NPM_PACKAGES PATH MANPATH NODE_PATH

# Chrome for karma
CHROME_BIN=/usr/bin/chromium-browser
export CHROME_BIN

# Python
WORKON_HOME=~/.virtualenvs
export WORKON_HOME
source /usr/bin/virtualenvwrapper.sh

source ~/.aliases
source ~/.functions


# Rust
export RUST_SRC_PATH="/home/jenselme/.cargo/rust/src"


# Go
export GOPATH="/home/jenselme/tests/go"
