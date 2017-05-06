from scapy.all import *
from threading import Timer
from time import sleep

if __name__ == '__main__':
    a = Ether(src='00:00:00:00:00:0b', dst='00:00:00:00:00:01')/IP(src='10.0.0.11', dst="192.168.0.11")/TCP(sport=8000, dport=80, flags="S") # port 1
    # a = Ether(src='00:00:00:00:00:0c', dst='00:00:00:00:00:02')/IP(src='10.0.0.12', dst="192.168.0.12")/TCP(sport=8000, dport=80, flags="S") # port 2
    # a = Ether(src='00:04:00:00:00:10', dst='00:aa:bb:00:00:04')/IP(src='10.0.0.10', dst="192.168.0.10")/TCP(sport=80, dport=10, flags="S")
    # a = IP(src='10.0.0.11', dst="192.168.0.11")/TCP(sport=8000, dport=80, flags="S")
    while (True):
        # send
        srp(a)
        # sleep 1 second
        sleep(1)
