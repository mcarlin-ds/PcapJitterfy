from pprint import pprint

def add_jitter(src, dst='out_scapy.pcap', jitter=0.001):
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
         newtime = t
      else:
         newtime = t + jitter*count
      p.time = newtime
      pmod = p
      if count > 0:
         diff = newtime - prev
      prev = t
      cooked.append(pmod)
      count = count + 1
   wrpcap(dst, cooked)
   print("Wrote to {} with jitter of {}s".format(dst, jitter))
