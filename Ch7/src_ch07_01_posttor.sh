#!/bin/sh

DEST=$HOME/tor
# set DEST above to the path of an existing, writeable directory

[ -n "$DEST" ] || { echo "$DEST is null !" 1>&2; exit 1; }
[ -d "$DEST" ] || { echo "$DEST not a directory !" 1>&2; exit 1; }
[ -w "$DEST" ] || { echo "$DEST not writeable !" 1>&2; exit 1; }

echo "From ${TR_TORRENT_DIR}:
Completed TR_TORRENT_NAME=${TR_TORRENT_NAME}
(TR_TORRENT_ID=${TR_TORRENT_ID})" >> $HOME/tor-messages

mv "${TR_TORRENT_NAME}" "$DEST"
exit $?
