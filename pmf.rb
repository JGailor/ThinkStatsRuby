module ThinkStats
  class HashWrapper
    attr_reader :hash, :name
    
    def initialize(hash = nil, name = '')
      @hash = hash || {}
      @name = name
    end
    
    def get_hash
      @hash
    end
    
    def values
      @hash.keys
    end
    
    def items
      @hash.to_a
    end
    
    def render
      self.items.sort.transpose
    end
    
    def print
      @hash.each {|k,v| puts "#{k} #{v}"}
    end
    
    def set(x, y = 0)
      @hash[x] = y
    end
    
    def incr(x, term = 1)
      @hash[x] = (@hash[x] || 0) + term
    end
    
    def mult(x, factor)
      @hash[x] = (@hash[x] || 0) * factor
    end
    
    def remove(x)
      @hash.delete(x)
    end
    
    def total
      @hash.inject(0) {|acc, (value, frequency)| acc += frequency}
    end
  end
  
  class Histogram < HashWrapper
    def copy(name = nil)
      Histogram.new(@hash.clone, (name || @name))
    end
    
    def freq(x)
      @hash[x] || 0
    end
    
    def freqs
      @hash.values
    end
    
    def subset?(other)
      @hash.all? {|value, frequency| other.freq(value) == frequency}
    end
    
    def subtract(other)
      other.items.each {|value, frequency| self.incr(value, -frequency)}
    end
  end
  
  class Pmf < Histogram
    def copy(name = nil)
      Pmf.new(@hash.clone, (name || @name))
    end
    
    def prob(x)
      @hash[x] || 0
    end
    
    def probs
      @hash.values
    end
    
    def normalize(fraction = 1.0)
      t = self.total
      
      raise 'Total probably is zero' if t == 0.0
      
      factor = fraction.to_f / total
      @hash.each {|value, frequency| @hash[value] = (@hash[value] || 0) * factor}
    end
    
    def random
      target = rand()
      total = 0.0
      for (val, prob) in @hash
        total += prob
        return x if total >= target
      end
      
      return x
    end
    
    def mean
      @hash.inject(0) {|acc, (val, prob)| acc += (val * prob)}
    end
    
    def var(mu = nil)
      mu = mu || self.mean
      @hash.inject(0) {|acc, (val, prob)| acc += (prob * (val - mu)**2)}
    end
  end
end