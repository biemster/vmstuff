#!/bin/bash

NIC=virtio # virtio,e1000

kvm -smp 2 -m 1024 \
  -kernel $1 \
  -drive file=$2,if=virtio \
  -net nic,model=$NIC,macaddr=52:54:00:12:34:56 \
  -net user,hostfwd=tcp:127.0.0.1:4444-:22 \
  -append 'root=/dev/vda1 rw'
#  -display none
