require 'test/unit'
require 'estimator'

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
end
