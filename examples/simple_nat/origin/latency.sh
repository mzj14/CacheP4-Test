#! /bin/bash

# repeat every 0.1 second
# repeat 100 times
# destination port 10
tcpping -r 0.1 -x 100 192.168.0.10 10 > latency.txt
