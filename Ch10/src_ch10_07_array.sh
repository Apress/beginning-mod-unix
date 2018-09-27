#!/usr/bin/env bash

dist=`uname -o`

declare -a unix        # optional

i=0

unix[$((i++))]="FreeBSD"
unix[$((i++))]="Linux"
unix[$((i++))]="Cygwin"

i=0
is_unix=false

while [ $i -lt ${#unix[@]} ]; do
    if [ "$dist" = "${unix[$i]}" ]; then
        is_unix=true
        break
    fi
    
    ((i++))
done

echo $is_unix
exit 0
