#!/usr/bin/env zsh

# From https://gist.github.com/jpouellet/5278239

# This script prints a bell character when a command finishes
# if it has been running for longer than $zbell_duration seconds.
# If there are programs that you know run long that you don't
# want to bell after, then add them to $zbell_ignore.
#
# This script uses only zsh builtins so its fast, there's no needless
# forking, and its only dependency is zsh and its standard modules
#
# Written by Jean-Philippe Ouellet <jpo@vt.edu>
# Made available under the ISC license.

# only do this if we're in an interactive shell
[[ -o interactive ]] || return


# get $EPOCHSECONDS. builtins are faster than date(1)
zmodload zsh/datetime || return


# make sure we can register hooks
autoload -Uz add-zsh-hook || return

# initialize zbell_duration if not set
(( ${+zbell_duration} )) || zbell_duration=${ZBELL_DURATION:-15}

# initialize zbell_ignore if not set
if [[ ${#ZBELL_CMD_IGNORE} -gt 0 ]] && (( ! ${+zbell_ignore} )); then
	zbell_ignore=()
	for ignore_cmd in ${ZBELL_CMD_IGNORE[*]}; do
		zbell_ignore+=("${ignore_cmd}")
	done
fi
(( ${+zbell_ignore} )) || zbell_ignore=($EDITOR $PAGER)

# initialize it because otherwise we compare a date and an empty string
# the first time we see the prompt. it's fine to have lastcmd empty on the
# initial run because it evaluates to an empty string, and splitting an
# empty string just results in an empty array.
zbell_timestamp=$EPOCHSECONDS

# right before we begin to execute something, store the time it started at
zbell_begin() {
	zbell_timestamp=$EPOCHSECONDS
	zbell_lastcmd=$1
}

# when it finishes, if it's been running longer than $zbell_duration,
# and we dont have an ignored command in the line, then print a bell.
zbell_end() {
	if [[ -z "${zbell_lastcmd}" ]]; then
		return
	fi

	time_run=$(( $EPOCHSECONDS - $zbell_timestamp ))
	ran_long=$(( $EPOCHSECONDS - $zbell_timestamp >= $zbell_duration ))

	has_ignored_cmd=0
	for ignore_cmd in ${zbell_ignore[*]}; do
		if [[ "${zbell_lastcmd}" == *"${ignore_cmd}"* ]]; then
			has_ignored_cmd=1
			break
		fi
	done

	if (( ! $has_ignored_cmd )) && (( ran_long )); then
		notify-send "'${zbell_lastcmd}' completed in ${time_run}"
	fi
	
	zbell_lastcmd=""
}

# register the functions as hooks
add-zsh-hook preexec zbell_begin
add-zsh-hook precmd zbell_end
