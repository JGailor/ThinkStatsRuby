$: << File.join(File.dirname(__FILE__), "..")
require 'survey'

pregnancies = ThinkStats::Pregnancies.new
pregnancies.read_records

by_ord = {:first => 0, :other => 0}.tap do |birth_order|
  pregnancies.records.each do |pregnancy|
    if pregnancy.outcome == 1
      pregnancy.birthord == 1 ? birth_order[:first] += 1 : birth_order[:other] += 1
    end
  end
end

puts "First borns (born live): #{by_ord[:first]}\nOthers (born live): #{by_ord[:other]}"