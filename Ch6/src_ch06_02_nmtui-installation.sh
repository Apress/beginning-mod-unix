ip link set <eth> up
ip addr add 192.168.1.100/24 broadcast 192.168.1.255 dev <eth>
ip route add default via 192.168.1.1
pacman -Ssy			#skip for Ubuntu
pacman -S networkmanager	#Ubuntu: apt-get install network-manager
systemctl enable NetworkManager #Ubuntu: systemctl enable network-manager
systemctl start NetworkManager  #Ubuntu: systemctl start network-manager
