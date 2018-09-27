oldifs="$IFS"
IFS=$'\n'

for f in `{ find /usr -type f -exec file {} \;; } | \
grep "ASCII text" | awk -F : '{print $1}'`; do
	echo "$f"
done

IFS="$oldifs"
