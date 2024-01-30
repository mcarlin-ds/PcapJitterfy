#!/usr/bin/env python3

import argparse
from scapy.all import rdpcap, wrpcap
from pprint import pprint
import numpy as np

def add_jitter(src, dst='out_scapy.pcap', jitter=0.001, freq=5):
   pkts = rdpcap(src)
   cooked=[]
   count=0
   base=0
   prev=0
   diff=0
   newtime=0
   for p in pkts:
      t=p.time
      if count < 1:
         newtime = t + jitter
      else:
         cycles = t * freq
         radians = (cycles - int(cycles)) * (2 * np.pi) 
         newtime = t + jitter + (jitter * np.sin(radians))
      p.time = newtime
      pmod = p
      if count > 0:
         diff = newtime - prev
      prev = t
      cooked.append(pmod)
      count = count + 1
   wrpcap(dst, cooked)
   print("Wrote to {} with peak-to-peak jitter of {}s at {} Hz".format(dst, jitter, freq))


 if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Add jitter to pcap file.')
    parser.add_argument('src', help='Source pcap file')
    parser.add_argument('dst', help='Destination pcap file')
    parser.add_argument('jitter', type=float, help='Jitter to add')
    parser.add_argument('freq', type=int, help='Frequency of jitter')

    args = parser.parse_args()

    add_jitter(args.src, args.dst, args.jitter, args.freq)