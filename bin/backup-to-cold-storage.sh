#!/usr/bin/env bash

set -e
set -u
set -o pipefail

source ~/.private/scw-configrc

function backup() {
    local extra_args="$@"

    for folder in "${!folders[@]}"; do
        echo "Backuping ${folder} to ${SCW_BUCKET}/${folders[$folder]}"
        duplicity incremental \
            --name=${folders[$folder]} \
            --full-if-older-than=1M \
            --asynchronous-upload \
            --s3-use-glacier \
            --progress \
            --encrypt-key=${DUPLICITY_GPG_ENCRYPT_KEY} \
            --sign-key=${DUPLICTIY_GPG_SIGN_KEY} \
            ${extra_args[@]} \
            "${folder}" \
            "${SCW_BUCKET}/${folders[$folder]}"
    done
}

function verify() {
    for folder in "${!folders[@]}"; do
        duplicity verify \
            --compare-data \
            --s3-use-glacier \
            --encrypt-key=${DUPLICITY_GPG_ENCRYPT_KEY} \
            --sign-key=${DUPLICTIY_GPG_SIGN_KEY} \
            "${SCW_BUCKET}/${folders[$folder]}" \
            "${folder}"
    done
}

function list() {
    for folder in "${!folders[@]}"; do
        echo "Listing files in ${SCW_BUCKET}/${folders[$folder]}"
        duplicity list-current-files \
            --s3-use-glacier \
            --encrypt-key=${DUPLICITY_GPG_ENCRYPT_KEY} \
            --sign-key=${DUPLICTIY_GPG_SIGN_KEY} \
            "${SCW_BUCKET}/${folders[$folder]}"
    done
}

function clean() {
    for folder in "${!folders[@]}"; do
        echo "Cleaning ${folders[$folder]}"
        duplicity remove-older-than 6M \
            --s3-use-glacier \
            --encrypt-key=${DUPLICITY_GPG_ENCRYPT_KEY} \
            --sign-key=${DUPLICTIY_GPG_SIGN_KEY} \
            "${SCW_BUCKET}/${folders[$folder]}"
    done
}

function restore() {
    local url_to_restore="$1"
    local restore_to=$(mktemp -d)

    echo "Restoring ${url_to_restore} to ${restore_to}"
    duplicity restore \
        --s3-use-glacier \
        --encrypt-key=${DUPLICITY_GPG_ENCRYPT_KEY} \
        --sign-key=${DUPLICTIY_GPG_SIGN_KEY} \
        "${url_to_restore}" \
        "${restore_to}"
}

function archive() {
    local path_to_save="$1"
    local dest="${archives[$path_to_save]}"

    echo "Saving ${path_to_save} to ${dest}"
    duplicity full \
        --s3-use-glacier \
        --asynchronous-upload \
        --progress \
        --encrypt-key=${DUPLICITY_GPG_ENCRYPT_KEY} \
        --sign-key=${DUPLICTIY_GPG_SIGN_KEY} \
        "${path_to_save}" \
        "${SCW_BUCKET}/${dest}"
    duplicity remove-all-but-n-full 1 --force "${SCW_BUCKET}/${dest}"
}

if [[ $# -ne 1 ]]; then
    echo "Illegal number of parameters. Use -h to view help." >&2
    exit 1
fi

while getopts "hbdvlcr:a:" opt; do
    case "${opt}" in
        h|\?)
            echo "Use -h for help, -b for backup, -d for dry run backup, -v for verify, -l to list, -c to clean up old and -r URL to restore. Will do for all backed up locations."
            echo "You can also use -a PATH to backup an archived path than doesn't change often."
            ;;
        b)
            backup
            ;;
        d)
            backup --dry-run
            ;;
        v)
            verify
            ;;
        l)
            list
            ;;
        c)
            clean
            ;;
        r)
            restore $OPTARG
            ;;
        a)
            archive $OPTARG
            ;;
    esac
done
