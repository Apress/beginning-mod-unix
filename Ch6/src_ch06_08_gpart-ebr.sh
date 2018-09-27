type mke2fs &>/dev/null || pkg install e2fsprogs

# Assuming ada0s1, ada0s2 and ada0s3 have already been created:

gpart add -t EBR ada0   # creates ada0s4 spanning remaining disk space

gpart create -s MBR ada0s4
# A gpart bug often prevents use of the EBR schema in the command above
# Else the proper command would be:  gpart create -s EBR ada0s4

gpart add -t linux-data ada0s4
# Reports addition of ada0s4s1, which shows up as ada0s5 upon reboot
# So reboot and then create the ext2 filesystem:

mke2fs ada0s5
