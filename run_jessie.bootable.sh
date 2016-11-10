sudo kvm -cpu host -smp 2 -m 1024 -hda jessie.bootable.img \
	-net nic,model=e1000,macaddr=52:54:00:12:34:56 \
	-net user,hostfwd=tcp::4444-:22 \
	-device e1000,netdev=net0,mac=52:54:00:12:34:57 \
	-netdev tap,id=net0,script=qemu-ifup