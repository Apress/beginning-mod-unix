#!/bin/sh

set -e      # exit upon first command failure

SERVER="ftp.freebsd.org"
DIR="pub/FreeBSD/releases/amd64/amd64/ISO-IMAGES/10.4"
PASSWORD="me@example.com"
FILE1="CHECKSUM.SHA256-FreeBSD-10.4-RELEASE-amd64"
FILE2="FreeBSD-10.4-RELEASE-amd64-mini-memstick.img.xz"

ftp -n $SERVER <<- EOF
    quote USER anonymous
    quote PASS "$PASSWORD"

    binary
    cd $DIR
    mget $FILE1 $FILE2
    bye
EOF

set +e
exit 0
