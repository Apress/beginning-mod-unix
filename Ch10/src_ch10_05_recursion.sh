#!/bin/sh

[ $# -gt 0 ] || { echo "Need path !" 1>&2; exit 1; }
[ -e "$1" ] || { echo "Need existing, valid path !" 1>&2; exit 1; }

path="$1"
counter=${2:-0}

if [ -L "$path" ]; then
    echo $path
else
    counter=`expr $counter + 1`

    if [ $counter -ge 32 ]; then
        echo "Recursion too deep! (>= 32)" 1>&2
        exit 1
    fi

    if echo $path | grep -q '\/'; then
        path=`echo $path | sed 's|/[^/]*$||'`
        
        if [ -n "$path" ]; then
            `basename $0` "$path" "$counter"    # recurse here
        fi
    fi
fi

exit 0
