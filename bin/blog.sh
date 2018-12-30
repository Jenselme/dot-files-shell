#!/usr/bin/env bash

stop_command() {
    if [[ -n "$1" ]] && (( "$1" > 1 )); then
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

get_pid() {
    pid=$(pgrep -fx "$1")
    until [ -n "${pid}" ]; do
	pid=$(pgrep -fx "$1")
    done
    echo "${pid}"
}


# switch to proper directory
# Cannot use pipenv shell here since it will spawn a new ZSH shell.
cd ~/server/www.jujens.eu

serve_pid=''

while true; do
    # Print errors for regenerate
    if [[ -n "${regenerate_pid}" ]] && has_died "${regenerate_pid}"; then
	echo -e "Regenerate has died with ouput:\n"
	cat <&3
    fi
    # Print errors for serve
    if [[ -n "${serve_pid}" ]] && has_died "${serve_pid}"; then
	echo -e "Serve has died with ouput:\n"
	cat <&4
    fi

    echo -en "(blog) > "
    read command
    # Quit on ^D
    if [[ "$?" == 1 ]]; then
        break;
    fi

    case "${command}" in
	deploy)
	    echo 'Pushing to jujens.eu'
	    git push --quiet
	    echo 'Killing serve pid'
	    stop_command "${serve_pid}"
	    if [[ -n "${serve_pid}" ]]; then
		cat <&4 > /dev/null 2>&1
	    fi
	    serve_pid=''
	    echo 'Rsync'
	    pipenv run make rsync_upload > /dev/null
	    ;;
	push)
	    git push --quiet
	    ;;
	st|status)
	    git st
	    ;;
	diff)
	    git diff
	    ;;
	add)
	    echo "Enter the filename to add (. for all files)"
	    read file_name
	    git add "${file_name}"
	    ;;
	ci|commit)
	    echo "Please enter the commit message:"
	    read commit_msg
	    git ci -am "${commit_msg}"
	    ;;
	pull)
	    git pull --quiet
	    ;;
	serve)
	    if [ -n "${serve_pid}" ] && ! has_died "${serve_pid}"; then
		echo "Serve is already running."
	    else
		exec 4< <(pipenv run make devserve 2>&1)
		serve_pid=$(get_pid 'python3 -m pelican.server')
	    fi
	    ;;
	"stop serve")
	    stop_command "${serve_pid}" > /dev/null
	    serve_pid=''
	    cat <&4 > /dev/null
	    ;;
	stop)
	    echo "Stop requires an argument: serve" >&2
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
            echo -e "\tst|status"
            echo -e "\tdiff"
            echo -e "\tadd"
            echo -e "\tci|commit"
	    echo -e "\tstop serve"
	    echo -e "\tstop regenerate"
	    echo -e "\thelp"
            echo -e "\tquit"
	    ;;
	*)
	    if [ -n "${command}" ]; then
		echo -e "${command} is invalid." >&2
	    fi
    esac
done

echo "Done"
