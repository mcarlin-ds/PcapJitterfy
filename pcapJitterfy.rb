#!/home/ross/.rvm/rubies/ruby-1.9.3-p392/bin/ruby

require 'packetfu'

mult = 1
jitter = 0.15

filename = ARGV[0] || nil
outfilename = ARGV[1] || nil
jitter = ARGV[2] || 0.15

if filename.nil? || outfilename.nil?
    p "Usage: #{__FILE__} [tracefile] [destination] [jitter=0.15]"
    exit
end

p "filename = #{filename}"

count = 0
#incap = PacketFu::Read.f2a(:file => filename)
 file = File.open(filename) {|f| f.read}
 #incap = PacketFu::PcapPackets.new
 incap = PacketFu::PcapFile.new
 incap = incap.read(file)

p "read file of size: #{incap.length}"
p "read file of size: #{incap.body.length}"

baseSec = incap.body.first.timestamp.sec.value
baseUsec = incap.body.first.timestamp.usec.value
baseTimeStr = "#{baseSec}.#{baseUsec}"
p "Base = #{baseTimeStr}"
baseTime = baseTimeStr.to_f
p "New Base = #{baseTime}"

prevTime = baseTime

incap.body.each do |p|
    sec = p.timestamp.sec.value
    usec = p.timestamp.usec.value
    timeStr = "#{sec}.#{usec}"
    time = timeStr.to_f
    diff = time - prevTime
    prevTime = time

    someJitter = mult * jitter * diff
    newTime = time + someJitter
    
    newPsec = newTime.to_s.split('.')[0]
    newPusec = newTime.to_s.split('.')[1]

    p.timestamp.sec.value = newPsec.to_i
    p.timestamp.usec.value = newPusec.to_i

    if true || newTime < 0 || count < 20
        p "(#{count})  #{time} ==> #{newTime} /// #{p.timestamp.sec.value}.#{p.timestamp.usec.value};  \tEffective Time: #{time - baseTime} ==> #{newTime - baseTime};  Diff = #{diff};  Jitter = #{(newTime-time)/diff}"
#        p " \=====>   #{p.inspect}"
    end


    count += 1
    mult *= -1  # flip the sign for jitter
end

puts "#{count} packets"
p "#{incap.length}, #{incap.body.length}"

File.open(outfilename,'wb') {|file| file.write(incap.to_s)}

#res = incap.write()

#bla = PacketFu::PcapFile.new
#bla.body = outcap
#
#p "."
#p "."
#p "NEW PCAP >>>>>>>>>>>>>>>>>>> #{bla.inspect}"
#p "."
#p "."
#res = bla.write()

#puts "result: #{res}"

#outcap.write()
