#! /bin/bash

ip link del veth1 type veth peer name veth3
ip link del veth2 type veth peer name veth4
ip netns del h1
ip netns del h2
