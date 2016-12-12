set -e
set -u


function main {
    declare -A dbs

    dbs[botta]=botta
    dbs[jenselme]=jenselme
    dbs[waffle_dev]=waffle_dba

    echo "Restoring dbs"
    for db in "${!dbs[@]}"; do
        echo "$db"
	psql -U postgres <<< "DROP DATABASE IF EXISTS ${db};
            CREATE DATABASE ${db} OWNER ${dbs[$db]};"
        pg_restore -h 127.0.0.1 -p 5432 -d "${db}" -U postgres ~/Seafile/Exchange/Work/db/$db.backup
    done
}


main

