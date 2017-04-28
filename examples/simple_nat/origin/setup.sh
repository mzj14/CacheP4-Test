#! /bin/bash

# create a veth device with two NIC -- veth1 and veth3
ip link add veth1 type veth peer name veth3

# create a veth device with two NIC -- veth2 and veth4
ip link add veth2 type veth peer name veth4

# set up a network namespace h1
ip netns add h1

# set up a network namespace h2
ip netns add h2

# add veth3 as an NIC to h1
ip link set veth3 netns h1

# add veth4 as an NIC to h2
ip link set veth4 netns h2

# start loopback NIC
ip netns exec h1 ifconfig lo up
ip netns exec h2 ifconfig lo up


# set MAC address of veth3 and veth4
ip netns exec h1 ifconfig veth3 hw ether 000400000010
ip netns exec h2 ifconfig veth4 hw ether 000500000010

# set IP address of veth3 and veth4
ip netns exec h1 ifconfig veth3 10.0.0.10  up
ip netns exec h2 ifconfig veth4 192.168.0.10  up

# bind IP address with MAC address
ip netns exec h1 arp -s 10.0.0.1 00:aa:bb:00:00:04
ip netns exec h2 arp -s 192.168.0.1 00:aa:bb:00:00:05

ip netns exec h1 route add default gw 10.0.0.1
ip netns exec h2 route add default gw 192.168.0.1

# set MAC address of veth1 and veth2
ifconfig veth1 hw ether 00aabb000004
ifconfig veth2 hw ether 00aabb000005

# activate veth1 and veth2
ifconfig veth1 10.0.0.1 up
ifconfig veth2 192.168.0.1 up
