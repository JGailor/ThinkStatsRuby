class Array

  class BisectionError < Exception; end

  # Usage:
  # [1,3,5,7,9,12,14,16].bisect { |a| a.even? }
  def bisect(options = {}, &block)
    raise BisectionError unless block_given?
    low_index = options[:low] || 0
    high_index = options[:high] || size - 1
    initial_state = nil

    case options[:mode]
      when :change
        initial_state = yield self[low_index]
      else
        initial_state = true
    end

    while low_index <= high_index
      mid_index = (low_index + high_index) / 2
      value = self[mid_index]
      result = yield(value)

      if result == initial_state
        low_index = mid_index + 1
      else
        high_index = mid_index - 1
      end
    end

    self[low_index] 
  end

end

module Bisectable
  
  class BisectionError < Exception; end

  def bisect(end_i, options = {}, &block)
    raise BisectionError unless block_given?
    low_index = self
    high_index = end_i
    initial_state = nil

    case options[:mode]
      when :change
        initial_state = yield self
      else
        initial_state = true
    end

    while low_index <= high_index
      mid_index = (low_index + high_index) / 2
      result = yield(mid_index)

      if result == initial_state
        low_index = mid_index + 1
      else
        high_index = mid_index - 1
      end
    end

    low_index 
  end
end

class Numeric; include Bisectable; end