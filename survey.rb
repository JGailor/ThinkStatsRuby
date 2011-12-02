require 'zlib'

module ThinkingStats
  class Record
  end

  class Respondent < Record
  end
  
  class Pregnancy < Record
  end
  
  
  class Table
    def initialize
      @records = []
    end
    
    def length
      @records.size
    end
    
    def read_file(data_dir, filename, fields, constructor, n = nil)
      filename = File.join(data_dir, filename)
      
      if filename.end_with?("gz")
        file = Zlib::GzipReader.open(filename)
      else
        file = File.open(filename)
      end
      
      i = 0
      file.each_line do |line|
        break if n && (i += 1) > n
        
        record = make_record(line, fields, constructor)
        add_record(record)
      end
      
      file.close
    end
    
    def make_record(line, fields, constructor)
      constructor.new.tap do |record|
        fields.each do |field|
          begin
            s = line[(field[:start]..field[:end])]
            val = field[:type].new(s)
          rescue
            val = 'NA'
          end
        
          constructor.instance_eval do
            attr_accessor field[:name].to_sym
          end
        
          record.send(:"#{field[:name]}=", val)
        end
      end
    end
    
    def add_record(record)
      @records << record
    end
    
    def extend_records(records)
      @records += records
    end
    
    def recode
    end
  end
  
  class Respondents < Table
    def read_records(data_dir = '.', n = nil)
      filename = get_file_name
      read_file(data_dir, filename, get_fields, Respondent, n)
      recode
    end
    
    def get_file_name
      "2002FemResp.dat.gz"
    end
    
    def get_fields
      [{:name => 'caseid', :start => 1, :end => 12, :type => Integer}]
    end
  end
  
  class Pregnancies < Table
    def read_records(data_dir = '.', n = nil)
      filename = get_file_name
      read_file(data_dir, filename, get_fields, Pregnancy, n)
      recode
    end
    
    def get_file_name
      "2002FemPreg.dat.gz"
    end
    
    def get_fields
      [{:name => 'caseid', :start => 1, :end => 12, :type => Integer},
       {:name => 'nbrnaliv', :start => 22, :end => 22, :type => Integer},
       {:name => 'babysex', :start => 56, :end => 56, :type => Integer},
       {:name => 'birthwgt_lb', :start => 57, :end => 58, :type => Integer},
       {:name => 'birthwgt_oz', :start => 59, :end => 60, :type => Integer},
       {:name => 'prglength', :start => 275, :end => 276, :type => Integer},
       {:name => 'outcome', :start => 277, :end => 277, :type => Integer},
       {:name => 'birthord', :start => 278, :end => 279, :type => Integer},
       {:name => 'agepreg', :start => 284, :end => 287, :type => Integer},
       {:name => 'finalwgt', :start => 423, :end => 440, :type => Float}]
    end
    
    def recode
      @records.each do |record|
        begin
          (record.agepreg /= 100.0) if record.agepreg != 'NA'
        rescue;end
        
        begin
          if record.birthwgt_lb != 'NA' && record.birthwgt_lb < 20 &&
             record.birthwgt_oz != 'NA' && record.birthwgt_oz <= 16
            record.totalwgt_oz = record.birthwgt_lb * 16 + record.birthwgt_oz
          else
            record.totalwgt_oz = 'NA'
          end
        rescue;end
      end
    end
  end
end

def main(data_dir = File.dirname(__FILE__))
  respondents = ThinkingStats::Respondents.new
  respondents.read_records(data_dir)
  puts "Number of respondents: #{respondents.length}"
  
  pregnancies = ThinkingStats::Pregnancies.new
  pregnancies.read_records(data_dir)
  puts "Number of pregnancies: #{pregnancies.length}"
end

if __FILE__ == $0
  main(*ARGV)
end