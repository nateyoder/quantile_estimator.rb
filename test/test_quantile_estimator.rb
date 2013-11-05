require 'test/unit'
require 'estimator'

# The current tests come from the implementation at
# https://github.com/odo/quantile_estimator

class QuantileEstimatorTest < Test::Unit::TestCase

  def test_biased_with_uniform_distribution
    invariant = Invariant::Biased.new(0.00001)
    estimator = Estimator.new(invariant)

    # Equivalent to: (1..10).to_a.shuffle
    test_values = [1, 4, 6, 5, 3, 10, 8, 9, 2, 7]
    test_values.each do |x|
      estimator.insert(x)
    end

    assert_equal 10, estimator.n
    assert_equal 5, estimator.query(0.45)

    # In this case it should not compress
    estimator.compress!

    assert_equal 10, estimator.n
    assert_equal 5, estimator.query(0.45)
    assert_equal 3, estimator.query(0.21)
  end

  def test_compression
    invariant = Invariant::Biased.new(0.2)
    estimator = Estimator.new(invariant)

    # Equivalent to: (1..10).to_a.shuffle
    test_values = [1, 4, 6, 5, 3, 10, 8, 9, 2, 7]
    test_values.each do |x|
      estimator.insert(x)
    end

    assert_equal 10, estimator.n
    assert_equal 6, estimator.query(0.45)

    estimator.compress!

    assert_equal 8, estimator.samples.length
    assert_equal 6, estimator.query(0.45)

    assert_equal 10, estimator.query(0.8)
  end

  def test_targeted_invariant
    invariant = Invariant::Targeted.new([
                                         [0.05, 0.02],
                                         [0.5,  0.02],
                                         [0.95, 0.02]
                                        ])

    estimator = Estimator.new(invariant)

    # Equivalent to: (1..10).to_a.shuffle
    test_values = [10, 29, 27, 17, 20,
                   6,  21, 13, 14, 2,
                   16, 8,  3,  9,  5,
                   7,  22, 12, 4,  11,
                   26, 18, 25, 28, 19,
                   30, 1,  23, 15, 24]

    test_values.each do |x|
      estimator.insert(x)
    end

    assert_equal 30, estimator.n
    assert_equal 30, estimator.samples.size
    assert_equal 15, estimator.query(0.45)

    estimator.compress!

    assert_equal 30, estimator.n
    assert_equal 26, estimator.samples.length

    assert_equal 16, estimator.query(0.5)
    assert_equal 30, estimator.query(0.95)
    assert_equal 2,  estimator.query(0.05)
  end
end
