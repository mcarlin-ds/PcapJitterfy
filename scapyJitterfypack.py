#!/usr/bin/env python3

import argparse
from scapy.all import rdpcap, wrpcap

def add_jitter(src, dst='out_scapy.pcap', pack=1):
   pkts = rdpcap(src)
   cooked=[]
   count=0
   for p in pkts:
      t=p.time
      if count % pack == 0:
         newtime = t
      else:
         newtime = newtime + 0.000001
      p.time = newtime
      pmod = p
      cooked.append(pmod)
      count = count + 1
   wrpcap(dst, cooked)
   print("Wrote to {} with pack factor of {}".format(dst, pack))


if __name__ == "__main__":
   parser = argparse.ArgumentParser(description='Add jitter to pcap file.')
   parser.add_argument('src', help='Source pcap file')
   parser.add_argument('dst', help='Destination pcap file')
   parser.add_argument('pack', type=int, help='number of packets to pack')

   args = parser.parse_args()

   add_jitter(args.src, args.dst, args.pack)