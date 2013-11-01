require 'invariant'
require 'item'

class Estimator
  attr_accessor :samples
  attr_reader :invariant

  class Cursor
    def initialize(array, start=0)
      @array = array
      @start = start
    end

    def ~
      @array[@start]
    end

    def remove!
      @array.delete_at(@start)
    end

    def next
      Cursor.new(@array, @start + 1)
    end
  end

  def initialize(invariant)
    @invariant = invariant
    self.samples = []
  end

  def n
    samples.length
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

    delta = if (i-1 < 0) || (i == n)
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
  end

  def compress!
    c = Cursor.new(self.samples.reverse!)
    while (~c != nil) && (~c.next != nil)
      if ((~c.next).g + (~c).g + (~c).delta).to_f <=
          invariant.upper_bound((~c.next).rank, n)
        removed    = ~c.next
        (~c).value = removed.value
        (~c).delta = removed.delta
        (~c).g    += removed.g
        c.next.remove!
      else
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
      while ~c != nil
        if rank + (~c).g + (~c).delta > (phi * n + invariant.upper_bound(phi * n, n) / 2)
          return (~c).value
        end
        rank = rank + (~c).g
        c = c.next
      end
    end
  end
end
