#! /bin/bash

# set up the net environment for host 1

# create namespaces
ip netns add h11
ip netns add h12

# add veths to namespaces
ip link set veth11 netns h11
ip link set veth12 netns h12

# configure NICs in namespaces
ip netns exec h11 ifconfig lo up
ip netns exec h11 ifconfig veth11 hw ether 00000000000b
ip netns exec h11 ethtool -K veth11 tso off
ip netns exec h11 ethtool -K veth11 gso off
ip netns exec h11 ethtool -K veth11 gro off
ip netns exec h11 ifconfig veth11 10.0.0.11 up

ip netns exec h12 ifconfig lo up
ip netns exec h12 ifconfig veth12 hw ether 00000000000c
ip netns exec h12 ethtool -K veth12 tso off
ip netns exec h12 ethtool -K veth12 gso off
ip netns exec h12 ethtool -K veth12 gro off
ip netns exec h12 ifconfig veth12 10.0.0.12 up

# configure arp for namespaces
ip netns exec h11 arp -s 10.0.1.11 00:00:00:00:01:0b
ip netns exec h11 arp -s 10.0.1.12 00:00:00:00:01:0c
ip netns exec h12 arp -s 10.0.1.11 00:00:00:00:01:0b
ip netns exec h12 arp -s 10.0.1.12 00:00:00:00:01:0c
