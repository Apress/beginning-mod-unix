gpart destroy -F da0 2>/dev/null
gpart create -s MBR da0
gpart add -t freebsd da0
gpart create -s BSD da0s1
gpart add -t freebsd-ufs da0s1
gpart bootcode -b /boot/boot0 da0
gpart bootcode -b /boot/boot da0s1
newfs -U /dev/da0s1a
mount /dev/da0s1a /mnt/bk
