$: << File.join(File.dirname(__FILE__), "..")

require 'survey'

table = ThinkStats::Pregnancies.new
table.read_records
puts "Number of pregnancies #{table.length}"
