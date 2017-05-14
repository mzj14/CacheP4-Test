#! /bin/bash

simple_switch -i 1@veth1 -i 2@veth2 -i 6@veth6 -i 7@veth7 -L off --thrift-port 9091 config.json
# --log-console
