function drop-test-db
    set -l database
    for database in (psql -h 127.0.0.1 -U django -p 5432 --list | grep '^ *test_' | awk '{print $1}')
        psql -h 127.0.0.1 -p 5432 -U django -d postgres --echo-all -c "DROP DATABASE $database;"
    end
end
