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
      @next ||= Cursor.new(@array, @start + 1)
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
              [0, @invariant.upper_bound(r_i, n).floor - 1].max
            end

    samples.insert(i, Item.new(value, 1, delta, r_i))
  end

  def compress!
    r_i = 0.0
    c = Cursor.new(self.samples)
    while (~c != nil) && (~c.next != nil)
      r_i = (~c).rank + (~c.next).value + (~c.next).delta
      if r_i <= @invariant.upper_bound(r_i, n)
        removed = ~c.next
        (~c).value = removed.value
        (~c).delta = removed.delta
        c.next.remove!
      end
      r_i += (~c).rank
      c = c.next
    end
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
