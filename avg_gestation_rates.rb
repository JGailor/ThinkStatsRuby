$: << File.dirname(__FILE__)

require 'survey'

pregnancies = ThinkStats::Pregnancies.new
pregnancies.read_records

puts "Average gestation period for first borns: #{pregnancies.records.inject([]) {|acc, p| acc << p.prglength if p.outcome == 1 && p.birthord == 1; acc}.average}"
puts "Average gestation period for non-first borns: #{pregnancies.records.inject([]) {|acc, p| acc << p.prglength if p.outcome == 1 && p.birthord != 1; acc}.average}"