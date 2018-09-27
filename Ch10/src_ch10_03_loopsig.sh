#!/bin/sh
trap "echo Trapped and ignored INTERRUPT" SIGINT
trap "echo Trapped TERMINATION; exit 255" SIGTERM
echo "Running with PID: $$"

n=0
while true; do
    n=$(( n+1 ))
    echo $n
    sleep 1
done
exit 0
