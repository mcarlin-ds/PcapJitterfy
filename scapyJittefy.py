from pprint import pprint

def add_jitter():
   pkts = rdpcap("/home/ross/Documents/redstone/PcapJitterfy/sample.pcap")
   cooked=[]
   count=0
   base=0
   prev=0
   diff=0
   newtime=0
   jitter=0.005
   for p in pkts:
      if count < 5:
         pprint(p)
         pprint(p.time)
         pprint(type(p.time))
      t=p.time
      if count < 2:
         newtime = t
      else:
         newtime = prev + jitter + diff
      p.time = newtime
      #if count < 20:
         #print("{} ==> {}".format(time,newtime))
      pmod = p
      if count > 0:
         diff = newtime - prev
      prev = t
      cooked.append(pmod)
      count = count + 1
   wrpcap("out_scapy.pcap", cooked)
