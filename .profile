#!/usr/bin/bash

# Android
#export ANDROID_HOME=/home/jenselme/Data/android-sdk-linux
#export ANDROID_SDK="${ANDROID_HOME}"
#export ANDROID_NDK="/opt/software/android-ndk"
#export ANDROID_PLATFORM_TOOLS="$ANDROID_SDK/platform-tools"

export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

PATH=/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/sbin:/home/$(whoami)/bin:"${ANDROID_HOME}/tools":"${ANDROID_HOME}/platform-tools":~/.perl6/bin:~/.cargo/bin:~/.local/bin
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
if [[ -f /usr/bin/virtualenvwrapper.sh ]]; then
    source /usr/bin/virtualenvwrapper.sh
elif [[ -f /usr/bin/virtualenvwrapper ]]; then
    source /usr/bin/virtualenvwrapper
elif [[ -f /usr/share/virtualenvwrapper/virtualenvwrapper.sh ]]; then
    source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
fi
export PATH="$HOME/.poetry/bin:$PATH"
export PYTHONBREAKPOINT="pudb.set_trace"
export PATH="$PYENV_ROOT/bin:$PATH"


# Perl6
PERL6LIB="inst#~/.perl6/"

source ~/.aliases
source ~/.functions

if [[ -f ~/.fns-specifics ]]; then
    source ~/.fns-specifics
fi


# Rust
export RUST_SRC_PATH="/home/$(whoami)/.cargo/rust/src"


# Go
export GOPATH="/home/$(whoami)/Projects/go"
PATH="$PATH:/home/$(whoami)/Projects/go/bin"


# Docker
if which ip > /dev/null; then
    export DOCKERHOST=$(ip -4 addr show docker0 | grep --only-matching -P 'inet \K[\d.]+')
fi

# KDE
if [[ -n "${KDE_FULL_SESSION}" ]]; then
    export SSH_ASKPASS='/usr/bin/ksshaskpass'
fi

# Enable anacron.
# To force execution, use anacron -t ~/.config/anachron -S $HOME/.local/share/var/spool/anacron -nf
anacron -t ~/.config/anachron -S $HOME/.local/share/var/spool/anacron

# Helm
HELM_V3_CONFIG=$PWD/.helm3
HELM_V3_DATA=$PWD/.helm3


# Added by Toolbox App
export PATH="$PATH:/home/jenselme/.local/share/JetBrains/Toolbox/scripts"
