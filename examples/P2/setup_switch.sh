#! /bin/bash

# set up net environment for switch

# configure NICs
ifconfig lo up
ifconfig veth1 hw ether 000000000001
ethtool -K veth1 tso off
ethtool -K veth1 gso off
ethtool -K veth1 gro off
ifconfig veth1 10.0.0.1 up

ifconfig veth2 hw ether 000000000002
ethtool -K veth2 tso off
ethtool -K veth2 gso off
ethtool -K veth2 gro off
ifconfig veth2 10.0.0.1 up

ifconfig veth6 hw ether 000000000101
ethtool -K veth6 tso off
ethtool -K veth6 gso off
ethtool -K veth6 gro off
ifconfig veth6 192.168.0.1 up

ifconfig veth7 hw ether 000000000102
ethtool -K veth7 tso off
ethtool -K veth7 gso off
ethtool -K veth7 gro off
ifconfig veth7 192.168.0.1 up
