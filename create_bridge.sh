#!/bin/sh

sudo ip link add br0 type bridge
sudo ifconfig br0 up
