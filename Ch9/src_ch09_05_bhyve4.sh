bhyve -c 1 -m 4G -H -w \
  -s 0,hostbridge \
  -s 4,ahci-hd,bhyve.img \
  -s 5,virtio-net,tap0 \
  -s 29,fbuf,tcp=0.0.0.0:5900,wait \
  -s 30,xhci,tablet \
  -s 31,lpc \
  -l com1,stdio \
  -l bootrom,/usr/local/share/uefi-firmware/BHYVE_UEFI.fd \
  win10
