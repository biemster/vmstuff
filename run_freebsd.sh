sudo kvm -cpu host -smp 2 -m 1024 -hda FreeBSD-11.0-RELEASE-amd64.qcow2 \
	-net nic,model=e1000,macaddr=52:54:00:12:34:58 \
	-net user,hostfwd=tcp::5555-:22 \
	-device e1000,netdev=net0,mac=52:54:00:12:34:59 \
	-netdev tap,id=net0,script=qemu-ifup
