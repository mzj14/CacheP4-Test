#! /bin/bash

# delete veths
ip link del veth1 type veth peer name veth11
ip link del veth2 type veth peer name veth12
ip link del veth3 type veth peer name veth13
ip link del veth4 type veth peer name veth14
ip link del veth5 type veth peer name veth15
ip link del veth6 type veth peer name veth16
ip link del veth7 type veth peer name veth17
ip link del veth8 type veth peer name veth18
ip link del veth9 type veth peer name veth19
ip link del veth10 type veth peer name veth20

# delete network namespaces
ip netns del h11
ip netns del h12
ip netns del h13
ip netns del h14
ip netns del h15
ip netns del h16
ip netns del h17
ip netns del h18
ip netns del h19
ip netns del h20
