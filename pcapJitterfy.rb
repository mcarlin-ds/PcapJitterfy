#!/home/ross/.rvm/rubies/ruby-1.9.3-p392/bin/ruby

require 'packetfu'

filename = ARGV[0] || nil
outfilename = ARGV[1] || 'out.pcap'
jitter = ARGV[2].to_f || 0.005

if filename.nil? || outfilename.nil? || jitter.nil?
    p "Usage: #{__FILE__} [src] [dest] [jitter=0.05]"
    p "       src: the pcap file to modify"
    p "       dest: the filename to put the modified pcap file"
    p "       jitter: the desired average jitter (per packet) in seconds"
    exit
end

p "args: #{filename} => #{outfilename}, jitter: #{jitter}"

count = 0
#incap = PacketFu::Read.f2a(:file => filename)
 file = File.open(filename) {|f| f.read}
 #incap = PacketFu::PcapPackets.new
 incap = PacketFu::PcapFile.new
 incap = incap.read(file)

p "read file of size: #{incap.length}"
p "read file of size: #{incap.body.length}"

prevDiff = 0
prevTime = 0
count = 0
baseTime = 0

incap.body.each do |p|
    timeStr = "#{p.timestamp.sec.value}.#{p.timestamp.usec.value}"
    time = timeStr.to_f
    if count == 0
        baseTime = time
    end
    if count < 2
        newTime = time
    else
        newTime = prevTime + jitter + prevDiff
    end

    newPsec = newTime.to_s.split('.')[0]
    newPusec = newTime.to_s.split('.')[1]

    p.timestamp.sec.value = newPsec.to_i
    p.timestamp.usec.value = newPusec.to_i

    if count < 20
        p "(#{count})  #{time} ==> #{newTime} /// #{p.timestamp.sec.value}.#{p.timestamp.usec.value};    Effective Time: #{time - baseTime rescue 'err'} ==> #{newTime - baseTime rescue 'err'};  PrevDiff = #{prevDiff}"
    elsif count < 25
        p p.inspect
    end

    prevDiff = newTime - prevTime rescue 0
    prevTime = time
    count += 1
end

puts "#{count} packets"
p "#{incap.length}, #{incap.body.length}"

File.open(outfilename,'wb') {|file| file.write(incap.to_s)}
