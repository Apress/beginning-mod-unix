#!/bin/sh
commenteer='#'
sed 's/^\('"$commenteer"'\)\(.*\)$/\2/'
exit $?
