#! /bin/bash

# create veths
ip link add veth1 type veth peer name veth11
ip link add veth2 type veth peer name veth12
ip link add veth3 type veth peer name veth13
ip link add veth4 type veth peer name veth14
ip link add veth5 type veth peer name veth15
ip link add veth6 type veth peer name veth16
ip link add veth7 type veth peer name veth17
ip link add veth8 type veth peer name veth18
ip link add veth9 type veth peer name veth19
ip link add veth10 type veth peer name veth20

# set up network namespaces
ip netns add h11
ip netns add h12
ip netns add h13
ip netns add h14
ip netns add h15
ip netns add h16
ip netns add h17
ip netns add h18
ip netns add h19
ip netns add h20

# add veths to namespaces
ip link set veth11 netns h11
ip link set veth12 netns h12
ip link set veth13 netns h13
ip link set veth14 netns h14
ip link set veth15 netns h15
ip link set veth16 netns h16
ip link set veth17 netns h17
ip link set veth18 netns h18
ip link set veth19 netns h19
ip link set veth20 netns h20

# configure NICs in namespaces
ip netns exec h11 ifconfig lo up
ip netns exec h11 ifconfig veth11 hw ether 00000000000b
ip netns exec h11 ifconfig veth11 10.0.0.11 up
ip netns exec h12 ifconfig lo up
ip netns exec h12 ifconfig veth12 hw ether 00000000000c
ip netns exec h12 ifconfig veth12 10.0.0.12 up
ip netns exec h13 ifconfig lo up
ip netns exec h13 ifconfig veth13 hw ether 00000000000d
ip netns exec h13 ifconfig veth13 10.0.0.13 up
ip netns exec h14 ifconfig lo up
ip netns exec h14 ifconfig veth14 hw ether 00000000000e
ip netns exec h14 ifconfig veth14 10.0.0.14 up
ip netns exec h15 ifconfig lo up
ip netns exec h15 ifconfig veth15 hw ether 00000000000f
ip netns exec h15 ifconfig veth15 10.0.0.15 up
ip netns exec h16 ifconfig lo up
ip netns exec h16 ifconfig veth16 hw ether 00000000010b
ip netns exec h16 ifconfig veth16 192.168.0.11 up
ip netns exec h17 ifconfig lo up
ip netns exec h17 ifconfig veth17 hw ether 00000000010c
ip netns exec h17 ifconfig veth17 192.168.0.12 up
ip netns exec h18 ifconfig lo up
ip netns exec h18 ifconfig veth18 hw ether 00000000010d
ip netns exec h18 ifconfig veth18 192.168.0.13 up
ip netns exec h19 ifconfig lo up
ip netns exec h19 ifconfig veth19 hw ether 00000000010e
ip netns exec h19 ifconfig veth19 192.168.0.14 up
ip netns exec h20 ifconfig lo up
ip netns exec h20 ifconfig veth20 hw ether 00000000010f
ip netns exec h20 ifconfig veth20 192.168.0.15 up

# configure NICs in main namespace
ifconfig lo up
ifconfig veth1 hw ether 000000000001
ifconfig veth1 10.0.0.1 up
ifconfig veth2 hw ether 000000000002
ifconfig veth2 10.0.0.1 up
ifconfig veth3 hw ether 000000000003
ifconfig veth3 10.0.0.1 up
ifconfig veth4 hw ether 000000000004
ifconfig veth4 10.0.0.1 up
ifconfig veth5 hw ether 000000000005
ifconfig veth5 10.0.0.1 up
ifconfig veth6 hw ether 000000000101
ifconfig veth6 192.168.0.1 up
ifconfig veth7 hw ether 000000000102
ifconfig veth7 192.168.0.1 up
ifconfig veth8 hw ether 000000000103
ifconfig veth8 192.168.0.1 up
ifconfig veth9 hw ether 000000000104
ifconfig veth9 192.168.0.1 up
ifconfig veth10 hw ether 000000000105
ifconfig veth10 192.168.0.1 up

# configure arp for namespaces
ip netns exec h11 arp -s 10.0.0.1 00:00:00:00:00:01
ip netns exec h12 arp -s 10.0.0.1 00:00:00:00:00:02
ip netns exec h13 arp -s 10.0.0.1 00:00:00:00:00:03
ip netns exec h14 arp -s 10.0.0.1 00:00:00:00:00:04
ip netns exec h15 arp -s 10.0.0.1 00:00:00:00:00:05
ip netns exec h16 arp -s 192.168.0.1 00:00:00:00:01:01
ip netns exec h17 arp -s 192.168.0.1 00:00:00:00:01:02
ip netns exec h18 arp -s 192.168.0.1 00:00:00:00:01:03
ip netns exec h19 arp -s 192.168.0.1 00:00:00:00:01:04
ip netns exec h20 arp -s 192.168.0.1 00:00:00:00:01:05

# configure default gateway for namespaces
ip netns exec h11 route add default gw 10.0.0.1
ip netns exec h12 route add default gw 10.0.0.1
ip netns exec h13 route add default gw 10.0.0.1
ip netns exec h14 route add default gw 10.0.0.1
ip netns exec h15 route add default gw 10.0.0.1

ip netns exec h16 route add default gw 192.168.0.1
ip netns exec h17 route add default gw 192.168.0.1
ip netns exec h18 route add default gw 192.168.0.1
ip netns exec h19 route add default gw 192.168.0.1
ip netns exec h20 route add default gw 192.168.0.1
