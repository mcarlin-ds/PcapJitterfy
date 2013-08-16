PcapJitterfy
============

Introduce jitter to a pcap file

Given a pcap file, adjust the timestamps to approach a given jitter amount

Usage
---------------
Install scapy (`sudo apt-get install python-scapy`), open it (`sudo scapy`), then copy/paste the contents of `scapyJitterfy.py` into the scapy terminal.

Now you can use the script like this:
   `add_jitter('<inputfilename>.pcap', '<outputfilename>.pcap', <avg_jitter_in_seconds>)`
