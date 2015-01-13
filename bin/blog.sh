#!/usr/bin/env bash

stop_command() {
    if [ "$1" ]; then
	kill "$1"
    fi
}

has_died() {
    if kill -0 "$1" > /dev/null 2>&1; then
	return 1
    else
	return 0
    fi
}

find_pid() {
    echo $(ps -elf | grep "$1" | grep -v '&&' | grep -v 'grep' | awk '{print $4}')
}

get_pid() {
    pid=$(find_pid "$1")
    until [ -n "${pid}" ]; do
	pid=$(find_pid "$1")
    done
    echo "${pid}"
}

# Activate venv
cd ~/server/blog/
source bin/activate
cd pelican/jujens.eu

regenerate_pid=''
serve_pid=''
# These variables cannot be used. If you try to use them, you will get an error like 3< not found.
#regenerate_output=3
#serve_output=4

while true; do
    # Print errors for regenerate
    if [ -n "${regenerate_pid}" ] && has_died "${regenerate_pid}"; then
	echo -e "Regenerate has died with ouput:\n"
	cat <&3
    fi
    # Print errors for serve
    if [ -n "${serve_pid}" ] && has_died "${serve_pid}"; then
	echo -e "Serve has died with ouput:\n"
	cat <&4
    fi

    echo -en "(blog) > "
    read command

    case "${command}" in
	deploy)
	    hg push > /dev/null
	    hg push bitbucket >/dev/null
	    stop_command "${serve_pid}"
	    stop_command "${regenerate_pid}"
	    serve_pid=''
	    regenerate_pid=''
	    cat <&3 > /dev/null 2>&1
	    cat <&4 > /dev/null 2>&1
	    make rsync_upload > /dev/null
	    ;;
	push)
	    hg push > /dev/null
	    hg push bitbucket > /dev/null
	    ;;
	st|status)
	    hg st
	    ;;
	diff)
	    hg diff
	    ;;
	add)
	    echo "Enter the filename to add (. for all files)"
	    read file_name
	    hg add "${file_name}"
	    ;;
	ci|commit)
	    echo "Please enter the commit message:"
	    read commit_msg
	    hg ci -m "${commit_msg}"
	    ;;
	serve)
	    if [ -n "${serve_pid}" ] && ! has_died "${serve_pid}"; then
		echo "Serve is already running."
	    else
		exec 4< <(make serve 2>&1)
		serve_pid=$(get_pid 'python3 -m pelican.server')
	    fi
	    ;;
	regenerate)
	    if [ -n "${regenerate_pid}" ] && ! has_died "${regenerate_pid}"; then
		echo "Regenerate is already running." >&2
	    else
		exec 3< <(make regenerate 2>&1)
		regenerate_pid=$(get_pid 'make regenerate')
	    fi
	    ;;
	"stop serve")
	    stop_command "${serve_pid}" > /dev/null
	    serve_pid=''
	    cat <&4 > /dev/null
	    ;;
	"stop regenerate")
	    stop_command "${regenerate_pid}" > /dev/null
	    regenerate_pid=''
	    cat <&3 > /dev/null
	    ;;
	stop)
	    echo "Stop requires an argument: serve or regenerate" >&2
	    ;;
	quit)
	    break
	    ;;
	help)
	    echo "Available commands:"
	    echo -e "\tdeploy"
	    echo -e "\tpush"
	    echo -e "\tserve"
	    echo -e "\tregenerate"
	    echo -e "\tstop serve"
	    echo -e "\tstop regenerate"
	    echo -e "\thelp"
	    ;;
	*)
	    if [ -n "${command}" ]; then
		echo -e "${command} is invalid." >&2
	    fi
    esac
done

echo "Done"
