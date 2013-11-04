require 'quantile_estimator/invariant'
require 'quantile_estimator/item'
require 'quantile_estimator/cursor'

class Estimator
  attr_accessor :samples
  attr_accessor :n
  attr_reader :invariant

  def initialize(invariant)
    @invariant = invariant
    self.samples = []
    self.n = 0
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
              [0, invariant.upper_bound(r_i, n).floor - 1].max
            end

    samples.insert(i, Item.new(value, 1, delta, r_i))

    while(i < samples.length)
      item = samples[i]
      r_i = r_i + item.g
      item.rank = r_i
      i += 1
    end

    self.n += 1
  end

  def compress!
    c = Cursor.new(self.samples.reverse!)
    while (~c != nil) && (~c.next != nil)
      if ((~c.next).g + (~c).g + (~c).delta).to_f <=
          invariant.upper_bound((~c.next).rank, n)
        removed   = ~c.next
        (~c).rank = removed.rank
        (~c).g   += removed.g
        c.next.remove!
      end
      c = c.next
    end
    self.samples.reverse!
  end

  def query(phi)
    if n == 0
      nil
    else
      rank = 0
      c = Cursor.new(samples)
      last = (~c).value
      while ~c != nil && ~c.next != nil
        last = (~c).value
        c = c.next
        rank += (~c).g
        phi_n = phi * n
        if (rank + (~c).g + (~c).delta) > (phi_n + (invariant.upper_bound(phi_n, n) / 2))
          return (~c).value
        end
      end
      return last
    end
  end
end
