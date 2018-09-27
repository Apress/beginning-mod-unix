pull()
{
	[ -n "$1" ] && wget ftp://10.0.2.2/xfer/"$1"
}

push()
{
	[ -f "$1" ] && wput "$1" ftp://10.0.2.2/xfer/
}
