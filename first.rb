print 2+2
print "\n"
2.times {print "sample \n"}

v1 = ARGV[0]
v2 = ARGV[1]
puts v1
puts v2

ARGV.each do|a|
  puts "Argument: #{a}"
end 