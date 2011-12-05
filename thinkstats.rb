require 'bisect'

module ThinkStats
  class ::Array
    # Computes the mean of a sequence of numbers
    def mean
      self.inject(0) {|acc, i| acc += i}.to_f / self.size
    end
  
    # Computes the variance of a sequence of numbers
    def var(mu = nil)
      mu = self.mean unless mu
      self.map {|x| (x - mu)**2}.mean
    end
  
    # Computes and returns the mean and variance of the sample
    def mean_var
      mu = self.mean
      v = self.var(mu)
      return [mu, v]
    end
  
    # Removes the largest & smalles elements of the sample
    def trim(p = 0.01)
      n = (p * self..size).to_i
      self.sort[n...-n]
    end
  
    # Computes the trimmed mean of a sequence of numbers
    def trimmed_mean(p = 0.01)
      self.trim(p).mean
    end
  
    # Computes the trimmed mean and variabnce of a sequence of numbers
    def trimmed_mean_var(p = 0.01)
      self.trim(p).mean_var
    end
  end
  
  # Computes the binomial coefficient 'n choose k'
  def binom(trials, successes, results = {})
    return 1 if k == 0
    return 0 if n == 0
  
    return results[[n,k]] if results.key?([n,k])
  
    (binom(n - 1, k) + binom(n - 1, k - 1)).tap do |res|
      d[[n, k]] = res
    end
  end
  
  class Interpolator
    attr_reader :xs, :ys
    
    def initialize(xs, ys)
      @xs = xs
      @ys = ys
    end
    
    def lookup(x)
      return bisect(x, @xs, @ys)
    end
    
    def reverse(y)
      return bisect(y, @ys, @xs)
    end
    
    private
      def bisect(x, xs, ys)
        return ys[0] if x <= xs[0]
        return ys[-1] if x >= xs[-1]
        
        i = xs.bisect {|i| i == x}
        frac = 1.0 * (x - xs[i - 1]) / (xs[i] - xs[i - 1])
        y = ys[i - 1] + frac * 1.0 * (ys[i] - ys[i - 1])
      end
  end
end