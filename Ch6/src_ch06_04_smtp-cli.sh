smtp-cli --ipv4 --auth \
--server="$SMTP" \
--port=$PORT \
--user="$fromaddr" \
--pass="$password" \
--from="$fromname <$fromaddr>" \
--to="$sendto" \
--subject="Scripting with Transmission" \
--body-plain=$HOME/notes/transmission-scripting.txt
