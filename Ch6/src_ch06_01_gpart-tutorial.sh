type mke2fs &>/dev/null || pkg install e2fsprogs
gpart destroy -F da0  2>/dev/null
gpart create -s MBR da0
gpart add -s 1G -t freebsd da0	# adds da0s1 as a slice
gpart create -s BSD da0s1	# creates BSD nesting schema on da0s1
gpart add -t freebsd-ufs da0s1	# creates partition da0s1a in the slice
gpart add -t linux-data da0     # adds da0s2 spanning remaining disk
newfs -U /dev/da0s1a
mke2fs /dev/da0s2
