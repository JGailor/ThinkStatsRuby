$: << File.join(File.dirname(__FILE__), "..")
require 'thinkstats'

pumpkin_weights = [1, 1, 3, 3, 591]

puts "Pumpkin weights mean is: #{pumpkin_weights.mean}"
puts "Pumpkin variance is: #{pumpkin_weights.var}"
puts "Pumpkin standard deviation is: #{Math.sqrt(pumpkin_weights.var)}"