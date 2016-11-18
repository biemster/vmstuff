#!/bin/bash

if [ $# -ne 1 ]; then
    REL=jessie
else
    REL=$1
fi

MIRROR=http://httpredir.debian.org

mkdir $REL
sudo debootstrap --include=openssh-server,build-essential,python,vim,git,pciutils,ca-certificates,linux-headers-amd64,linux-image-amd64 $REL $REL $MIRROR/debian

# clear root password
sudo sed -i '/^root/ { s/:x:/::/ }' ./$REL/etc/passwd

# Automatically bring up eth0 using DHCP
printf '\nauto eth0\niface eth0 inet dhcp\n' | sudo tee -a ./$REL/etc/network/interfaces
# Automatically bring up eth1 with static ip
printf '\nauto eth1\niface eth1 inet static\naddress 192.168.1.57\nnetmask 255.255.0.0\n' | sudo tee -a ./$REL/etc/network/interfaces

# mount rootfs rw on boot
echo "/dev/sda1 / ext4 defaults,noatime,rw,errors=remount-ro 0 1" | sudo tee -a ./$REL/etc/fstab

# Set up my ssh pubkey for root in the VM
sudo mkdir ./$REL/root/.ssh/
cat ~/.ssh/id_?sa.pub | sudo tee ./$REL/root/.ssh/authorized_keys

# make img
dd if=/dev/zero of=$REL.img bs=1M seek=1k count=1
mkfs.ext4 -F $REL.img
mkdir -p mnt
sudo mount -o loop $REL.img mnt
sudo cp -a ./$REL/. mnt/.
sudo umount --force mnt
rmdir mnt

# make bootimg
cp mbr.img $REL.bootable.img
pv $REL.img >> $REL.bootable.img

# convert to 100G qcow2
qemu-img convert -f raw -O qcow2 $REL.bootable.img $REL.qcow2
qemu-img resize $REL.qcow2 +99G

echo "--------------------"
echo "DONE creating image."
echo "Now boot into the bootable image using run_kvm.sh and a kernel"
echo "supporting virtio, login as root, and resize the rootfs:"
echo "	# fdisk /dev/vda (delete partition 'd', create new 'n', activate 'a', write 'w')"
echo "	# resize2fs /dev/vda1"
echo "reboot"
echo "    # apt-get install grub2"
echo "After that you can boot the vm using kvm -hda $REL.qcow2"
echo "--------------------"
