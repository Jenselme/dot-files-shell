#!/usr/bin/bash

PATH=/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/sbin:/home/jenselme/bin
export PATH

# env variable for git
GIT_COMMITTER_EMAIL="julien.enselme@centrale-marseille.fr"
GIT_COMMITTER_NAME="Julien Enselme"
GIT_AUTHOR_EMAIL=$GIT_COMMITTER_EMAIL
GIT_AUTHOR_NAME=$GIT_COMMITTER_NAME
export GIT_COMMITTER_EMAIL GIT_COMMITTER_NAME GIT_AUTHOR_EMAIL GIT_AUTHOR_NAME
