$: << File.dirname(__FILE__)

require 'survey'

table = ThinkingStats::Pregnancies.new
table.read_records
puts "Number of pregnancies #{table.length}"
