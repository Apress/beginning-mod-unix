#!/bin/sh
commenteer='#'
sed 's/^.*$/'"$commenteer"'&/'
exit $?
