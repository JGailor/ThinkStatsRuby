$: << File.join(File.dirname(__FILE__), "..")

require 'survey'

table = ThinkStats::Pregnancies.new
table.read_records

live_births = table.records.inject(0) {|acc, record| acc += 1 if record.outcome == 1;acc}

puts "The number of live births was #{live_births}"
