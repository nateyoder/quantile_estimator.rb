module Invariant
  class Invariant
    def upper_bound(rank, n)
      raise "Implement me"
    end
  end

  class Biased < Invariant
    def initialize(epsilon)
      @epsilon = epsilon
    end

    def upper_bound(rank, n)
      2 * @epsilon * rank
    end
  end

  class SingleTarget < Invariant
    def initialize(phi, epsilon)
      @phi = phi
      @epsilon = epsilon
    end

    def upper_bound(rank, n)
      if @phi * n <= rank
        (2 * @epsilon * rank) / @phi
      else
        (2 * @epsilon * (n - rank)) / (1 - @phi)
      end
    end
  end

  class Targeted < Invariant
    def initialize(target_values)
      @targets = target_values.map { |target_value|
        phi, epsilon = target_value
        SingleTarget.new(phi, epsilon)
      }
    end

    def upper_bound(rank, n)
      @targets.map { |target|
        target.upper_bound(rank, n)
      }.min
    end
  end
end
