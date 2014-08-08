#!/usr/bin/bash

case "$1" in
	"blog")
		/bin/bash --rcfile ~/bin/blog-pelican.sh
		;;
	*)
		echo "Not a valid virtualenv."
		;;
esac
