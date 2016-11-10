#!/bin/sh

sudo ip link add br0 type bridge
echo "Now wait for bridge to appear in ifconfig, then bring it up:"
echo "    # ifconfig br0 up"
