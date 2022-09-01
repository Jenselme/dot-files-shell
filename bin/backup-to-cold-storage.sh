#!/usr/bin/env bash

set -e
set -u
set -o pipefail

source ~/.private/scw-configrc

function backup() {
    local extra_args="$@"

    for folder in "${!folders[@]}"; do
        echo "Backuping ${folder} to ${SCW_ARCHIVE_TARGET}/${folders[$folder]}"
        sync-with-bucket "${SCW_ARCHIVE_TARGET}/${folders[$folder]}" "${DUPLICITY_ARCHIVE_TARGET}/${folders[$folder]}"
        duplicity incremental \
            --name=${folders[$folder]} \
            --full-if-older-than=1M \
            --progress \
            --encrypt-key=${DUPLICITY_GPG_ENCRYPT_KEY} \
            --sign-key=${DUPLICTIY_GPG_SIGN_KEY} \
            ${extra_args[@]} \
            "${folder}" \
            "file://${DUPLICITY_ARCHIVE_TARGET}/${folders[$folder]}"
        sync-with-bucket "${DUPLICITY_ARCHIVE_TARGET}/${folders[$folder]}" "${SCW_ARCHIVE_TARGET}/${folders[$folder]}"
    done
}

function sync-with-bucket() {
    local source="$1"
    local dest="$2"

    aws s3 sync "${source}" "${dest}" \
            --profile duplicity \
            --endpoint-url https://s3.fr-par.scw.cloud \
            --delete
}

function verify() {
    for folder in "${!folders[@]}"; do
        sync-with-bucket "${SCW_ARCHIVE_TARGET}/${folders[$folder]}" "${DUPLICITY_ARCHIVE_TARGET}/${folders[$folder]}"
        duplicity verify \
            --compare-data \
            --encrypt-key=${DUPLICITY_GPG_ENCRYPT_KEY} \
            --sign-key=${DUPLICTIY_GPG_SIGN_KEY} \
            "file://${DUPLICITY_ARCHIVE_TARGET}/${folders[$folder]}" \
            "${folder}"
    done
}

function list() {
    for folder in "${!folders[@]}"; do
        echo "Listing files in ${SCW_ARCHIVE_TARGET}/${folders[$folder]}"
        sync-with-bucket "${SCW_ARCHIVE_TARGET}/${folders[$folder]}" "${DUPLICITY_ARCHIVE_TARGET}/${folders[$folder]}"
        duplicity list-current-files \
            --encrypt-key=${DUPLICITY_GPG_ENCRYPT_KEY} \
            --sign-key=${DUPLICTIY_GPG_SIGN_KEY} \
            "file://${DUPLICITY_ARCHIVE_TARGET}/${folders[$folder]}"
    done
}

function clean() {
    for folder in "${!folders[@]}"; do
        echo "Cleaning ${folders[$folder]}"
        sync-with-bucket "${SCW_ARCHIVE_TARGET}/${folders[$folder]}" "${DUPLICITY_ARCHIVE_TARGET}/${folders[$folder]}"
        duplicity remove-older-than 6M \
            --encrypt-key=${DUPLICITY_GPG_ENCRYPT_KEY} \
            --sign-key=${DUPLICTIY_GPG_SIGN_KEY} \
            "file://${DUPLICITY_ARCHIVE_TARGET}/${folders[$folder]}"
        sync-with-bucket "${DUPLICITY_ARCHIVE_TARGET}/${folders[$folder]}" "${SCW_ARCHIVE_TARGET}/${folders[$folder]}"
    done
}

function restore() {
    local url_to_restore="$1"
    local restore_to=$(mktemp -d)

    echo "Restoring ${url_to_restore} to ${restore_to}"
    sync-with-bucket "${SCW_ARCHIVE_TARGET}/${folders[$folder]}" "${DUPLICITY_ARCHIVE_TARGET}/${folders[$folder]}"
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
    sync-with-bucket "${SCW_ARCHIVE_TARGET}/${dest}" "${DUPLICITY_ARCHIVE_TARGET}/${dest}"
    duplicity full \
        --progress \
        --encrypt-key=${DUPLICITY_GPG_ENCRYPT_KEY} \
        --sign-key=${DUPLICTIY_GPG_SIGN_KEY} \
        "${path_to_save}" \
        "file://${DUPLICITY_ARCHIVE_TARGET}/${dest}"
    duplicity remove-all-but-n-full 1 --force "file://${DUPLICITY_ARCHIVE_TARGET}/${dest}"
    sync-with-bucket "${DUPLICITY_ARCHIVE_TARGET}/${dest}" "${SCW_ARCHIVE_TARGET}/${dest}"
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
