#! /bin/bash

# set up net environment for 101.6.30.156

# configure NICs
ifconfig lo up
ifconfig veth1 hw ether 000000000001
ethtool -K veth1 tso off
ethtool -K veth1 gso off
ethtool -K veth1 gro off
ifconfig veth1 10.0.0.1 up

ifconfig veth2 hw ether 000000000002
ethtool -K veth1 tso off
ethtool -K veth1 gso off
ethtool -K veth1 gro off
ifconfig veth2 10.0.0.1 up

ifconfig veth6 hw ether 000000000101
ethtool -K veth1 tso off
ethtool -K veth1 gso off
ethtool -K veth1 gro off
ifconfig veth6 192.168.0.1 up

ifconfig veth7 hw ether 000000000102
ethtool -K veth1 tso off
ethtool -K veth1 gso off
ethtool -K veth1 gro off
ifconfig veth7 192.168.0.1 up
