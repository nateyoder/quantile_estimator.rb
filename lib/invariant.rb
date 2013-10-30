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

  class Targeted < Invariant
    # Implement me
  end
end
