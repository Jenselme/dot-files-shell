#!/usr/bin/env bash

help="mysql_drop_table_like [options] database pattern

Drop all the mysql tables in database that starts with pattern.

-h: host
-u: user
-pPASSWD: give password
-P: prompt for password
"

usage() {
    echo -e $help
}

pflag=false
Pflag=false
uflag=false
hflag=false

while getopts ":h:u:p:P" opt
do
    case "$opt" in
	h)
	    host="$OPTARG"; hflag=true;;
	u)
	    user="$OPTARG"; uflag=true;;
	p)
	    passwd="$OPTARG"; pflag=true;;
	P)
	    Pflag=true;;
	:)
	    echo "Option -$OPTARG requires an argument." >&2
	    usage; exit 1;;
	\?)
	    usage; exit 0;;
    esac
done
shift $((OPTIND-1)) # To get the 1st positional argument with $1

# Check that we have at least 2 positional arguments
if (( $# > 2 )) ; then
    echo "Number of positional arguments insuffisant." >&2
    usage >&2
    exit 1
fi

# Cannot provide and ask for password
if "$Pflag" && "$pflag"; then
    echo "Cannot provide and ask for password." >&2
    usage >&2
    exit 1
fi

if "$hflag"; then
    HOST="-h $host"
fi
if "$pflag"; then
    PASSWD="-p$passwd"
fi
if "$Pflag"; then
    PASSWD="-p"
fi
if "$uflag"; then
    USER="-u $user"
fi

mysql="mysql $HOST $PASSWD $USER"
for table in "$($mysql $1 -NBe "SHOW TABLES LIKE '$2%'")"; do
    "$mysql" "$1" -e "DROP TABLE $table"
done
