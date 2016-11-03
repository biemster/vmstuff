#!/bin/bash

if [ $# -ne 1 ]; then
    REL=jessie
else
    REL=$1
fi

MIRROR=http://ftp.nl.debian.org

mkdir $REL
sudo debootstrap --include=openssh-server,build-essential,vim,git,linux-headers-amd64,linux-image-amd64 $REL $REL $MIRROR/debian

# clear root password
sudo sed -i '/^root/ { s/:x:/::/ }' $REL/etc/passwd

# Automatically bring up eth0 using DHCP
printf '\nauto eth0\niface eth0 inet dhcp\n' | sudo tee -a $REL/etc/network/interfaces

# mount rootfs rw on boot
echo "/dev/sda1 / ext4 defaults,noatime,ro,errors=remount-ro 0 1" | sudo tee -a $REL/etc/fstab

# Set up my ssh pubkey for root in the VM
sudo mkdir $REL/root/.ssh/
cat ~/.ssh/id_?sa.pub | sudo tee $REL/root/.ssh/authorized_keys

# make img
dd if=/dev/zero of=$REL.img bs=1M seek=1k count=1
mkfs.ext4 -F $REL.img
mkdir -p mnt
sudo mount -o loop $REL.img mnt
sudo cp -a $REL/. mnt/.
sudo umount mnt
rmdir mnt

# make bootimg
dd if=/dev/zero of=$REL.bootable.img count=1 bs=1MiB
pv $REL.img >> $REL.bootable.img
sfdisk $REL.bootable.img < imglayout

echo "DONE creating image."
echo "Now boot into the bootable image using run_kvm.sh, login as root, mount -o remount,rw /dev/sda1;apt-get update; apt-get install grub2."
echo "After that you can boot the vm using kvm -hda $REL.bootable.img"
