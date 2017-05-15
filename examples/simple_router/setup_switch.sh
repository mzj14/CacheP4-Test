#! /bin/bash

# set up net environment for 101.6.30.156

# configure NICs
ifconfig lo up
ifconfig veth1 hw ether 000000000001 up
ifconfig veth2 hw ether 000000000002 up
ifconfig veth6 hw ether 000000000101 up
ifconfig veth7 hw ether 000000000102 up
