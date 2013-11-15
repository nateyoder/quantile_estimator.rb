require 'quantile_estimator/invariant'
require 'quantile_estimator/item'
require 'quantile_estimator/cursor'

class Estimator
  attr_accessor :samples
  attr_accessor :n
  attr_reader :invariant

  # Creates a new quantile Estimator object using the provided invariant.
  #
  # == Parameters:
  # value::
  #   An Invariant object
  #
  def initialize(invariant)
    @invariant = invariant
    self.samples = []
    self.n = 0
  end

  # Inserts a new element into the quantile estimator.
  # O(n), where n is the number of elements of the internal data structure
  #
  # == Parameters:
  # value::
  #   A Fixnum to observe
  #
  # == Returns:
  # The number of observations after the insertion
  #
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

  # Compresses the internal data-structure.
  # O(n), where n is the number of elements of the internal data structure
  #
  # == Parameters:
  #
  # == Returns:
  #  The new size of the data-structure
  def compress!
    c = Cursor.new(self.samples, self.samples.length - 1)
    while (~c != nil) && (~c.previous != nil)
      if ((~c.previous).g + (~c).g + (~c).delta).to_f <=
          invariant.upper_bound((~c.previous).rank, n)
        removed   = ~c.previous
        (~c).rank = removed.rank
        (~c).g   += removed.g
        c.previous.remove!
        c = c.previous
      end
      c = c.previous
    end
    self.samples.length
  end

  # Queries de estimator for the given rank.
  # O(n), where n is the number of elements of the internal data structure
  #
  # == Parameters:
  # phi::
  #
  # A Fixnum between (0, 1) representing the rank to be queried (i.e, 0.5 represents
  # the 50% quantile)
  #
  # == Returns:
  # The approximate value for the quantile you are checking
  #
  def query(phi)
    if n == 0
      nil
    else
      rank = 0
      c = Cursor.new(samples)
      phi_n = phi * n
      last = (~c).value
      while ~c != nil
        last = (~c).value
        break if ~c.next == nil
        c = c.next

        if (rank + (~c).g + (~c).delta) > (phi_n + (invariant.upper_bound(phi_n, n) / 2))
          return last
        end

        rank += (~c).g
      end

      return (~c).value
    end
  end
end
