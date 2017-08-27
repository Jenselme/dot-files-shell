#!/usr/bin/bash

# Android
export ANDROID_HOME=/home/jenselme/Data/android-sdk-linux
export ANDROID_SDK="${ANDROID_HOME}"
#export ANDROID_NDK="/opt/software/android-ndk"
export ANDROID_PLATFORM_TOOLS="$ANDROID_SDK/platform-tools"

PATH=/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/sbin:/home/jenselme/bin:"${ANDROID_HOME}/tools":"${ANDROID_HOME}/platform-tools":~/.perl6/bin:~/.cargo/bin:~/.local/bin
export PATH

# Node
PATH="$HOME/.nvm/versions/node/v$(cat ~/.nvm/alias/default)/bin:$PATH"
NVM_DIR="$HOME/.nvm"
export NVM_DIR
source "$NVM_DIR/nvm.sh"
source "$NVM_DIR/bash_completion"

# Chrome for karma
CHROME_BIN=/usr/bin/chromium-browser
export CHROME_BIN

# Python
WORKON_HOME=~/.virtualenvs
export WORKON_HOME
source /usr/bin/virtualenvwrapper.sh

# Perl6
PERL6LIB="inst#~/.perl6/"

source ~/.aliases
source ~/.functions

if [[ -f ~/.fns-specifics ]]; then
    source ~/.fns-specifics
fi


# Rust
export RUST_SRC_PATH="/home/jenselme/.cargo/rust/src"


# Go
export GOPATH="/home/jenselme/Projects/go"
