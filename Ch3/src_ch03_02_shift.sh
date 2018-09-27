#!/bin/sh

optX=false
optY=false

while [ $# -gt 0 ]; do
	case "$1" in
	-x)
		optX=true
		shift
	;;

	-y)
		optY=true
		shift
	;;

	*)
		echo "Invalid arg: $1" 1>&2
		exit 1
	;;
	esac
done

exit 0
