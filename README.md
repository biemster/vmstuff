# vmstuff
All credits go to https://blog.nelhage.com/2013/12/lightweight-linux-kernel-development-with-kvm/ and https://blog.filippo.io/converting-a-partition-image-to-a-bootable-disk-image/

For the netmap initramfs where the init is used for read the following:
http://mgalgs.github.io/2015/05/16/how-to-build-a-custom-linux-kernel-for-qemu-2015-edition.html

compile netmap with
./configure --drivers=e1000 --kernel-sources=$TOP/linux-4.8.8 --kernel-dir=$TOP/obj/linux-x86-basic; make
and find libs needed for pkt-gen using ldd
