require "invariant"

class Estimator
  attr_accessor :samples
  attr_reader :invariant

  def initialize(invariant)
    @invariant = invariant
    self.samples = []
  end

  def insert(value)
    i = 0
    r_i = 0

    while(i < samples.length)
      item = samples[i]
      break if item.value > value # determines the order
      r_i = r_i + item.g
      i += 1
    end
    delta = if (i-1 < 0) || (i == samples.length)
              0
            else
              # r_i
              @invariant.upper_bound(r_i, samples.length).floor - 1
            end

    item = Item.new(value, 1, delta)
    samples.insert(i, item)
  end

  def compress!
    n = samples.length
    i = n - 2
    accum = []
    while(i >= 1)
      current = samples[i]
      next_one = samples[i+1]
      q = current.g + next_one.g + next_one.delta
      if(q <= invariant.upper_bound(samples[i].rank, n))
        # p current
        # p next_one
        # p current.merge(next_one)
        samples[i+1] = current.merge(next_one)
        samples.delete_at(i)
      end
      i -= 1
    end
    # self.samples = accum.reverse
    self.samples
  end

  def query(phi)
    r_i = 0
    (1..(samples.size-1)).each do |i|
      previous = samples[i - 1]
      r_i = r_i + previous.g

      item = samples[i]
      n = samples.length
      error = phi * n + (invariant.upper_bound(phi * n, n) /2)

      if(r_i + item.g + item.delta > error)
        return previous.value
      end
    end
    nil
  end
end
