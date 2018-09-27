rsync -aAHXv --delete --exclude-from /root/excl / /mnt/bk/

# Under Linux, adjust the next line for device node and fstype:
echo '/dev/da0s1a / ufs rw 0 0' > /mnt/bk/etc/fstab

# Save the current fstab too for reference (optional):
cp /etc/fstab /mnt/bk/etc/fstab_original

umount /mnt/bk
