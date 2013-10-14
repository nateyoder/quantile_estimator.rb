class QuantileEstimator
  attr_accessor :samples
  attr_reader :invariant

  def initialize(invariant)
    @invariant = invariant
    self.samples = []
  end

  def insert(value)
    idx = 0
    item =
      if self.samples.length > 0
        last_item = nil
        samples.each do |item|
          if value < item.value
            last_item = item
            last_item.rank = 0
            break
          else
            item.rank = self.samples[idx-1].rank + item.g if (idx - 1 > 0)
            last_item = item
            idx += 1 if idx < samples.length
          end
        end
        invariant = @invariant.upper_bound(last_item.rank, samples.length)
        # puts invariant
        Item.new(value, 1, invariant.to_f.floor - 1)
      else
        Item.new(value, 1, 0)
      end
    samples.insert(idx, item)
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
        accum << current.merge(next_one)
      else
        accum << current
      end
      i -= 1
    end
    self.samples = accum.reverse
    p self.samples
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
  end
end
