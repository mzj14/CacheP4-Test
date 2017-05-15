#! /bin/bash

# set up the net environment for 101.6.30.157

# create namespaces
ip netns add h16
ip netns add h17

# add veths to namespaces
ip link set veth16 netns h16
ip link set veth17 netns h17

# configure NICs in namespaces
ip netns exec h16 ifconfig lo up
ip netns exec h16 ifconfig veth16 hw ether 00000000010b
ip netns exec h16 ethtool -K veth16 tso off
ip netns exec h16 ethtool -K veth16 gso off
ip netns exec h16 ethtool -K veth16 gro off
ip netns exec h16 ifconfig veth16 10.0.1.11 up

ip netns exec h17 ifconfig lo up
ip netns exec h17 ifconfig veth17 hw ether 00000000010c
ip netns exec h17 ethtool -K veth17 tso off
ip netns exec h17 ethtool -K veth17 gso off
ip netns exec h17 ethtool -K veth17 gro off
ip netns exec h17 ifconfig veth17 10.0.1.12 up

# configure arp for namespaces
ip netns exec h16 arp -s 10.0.0.11 00:00:00:00:00:0b
ip netns exec h16 arp -s 10.0.0.12 00:00:00:00:00:0c
ip netns exec h17 arp -s 10.0.0.11 00:00:00:00:00:0b
ip netns exec h17 arp -s 10.0.0.12 00:00:00:00:00:0c
