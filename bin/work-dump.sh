set -e
set -u


function main {
    declare -A dbs

    dbs[botta]=botta
    dbs[jenselme]=jenselme
    dbs[waffle_dev]=waffle_dba

    echo "Saving dbs"
    for db in "${!dbs[@]}"; do
        echo "$db"
        pg_dump -h 127.0.0.1 -p 5432 -d "${db}" -U "${dbs[$db]}" -f ~/Seafile/Exchange/Work/db/$db.backup --format c
    done
}


main

