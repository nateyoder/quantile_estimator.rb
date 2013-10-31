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

    # In this case it doesn't compress
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
    puts "DEBUG"
    puts estimator.samples

    estimator.compress!

    assert_equal 8,  estimator.n
    assert_equal 6, estimator.query(0.45)
    assert_equal 10, estimator.query(0.8)
  end
end

# require "rubygems"
# require "quantile_estimator"
# require "item"
# require "invariant"

# # quantile = Quantile.new
# # quantile.quantile, quantile.error = 0.90, 0.001

# invariant = BiasedInvariant.new(0.00001)
# quantile_estimator = QuantileEstimator.new(invariant)

# # (1..1000).each do |x|
# #   # quantile_estimator.insert((1..1000).to_a[(rand * 100).floor])
# #   quantile_estimator.insert(rand)
# #   if x % 50 == 1
# #     p "size #{quantile_estimator.samples.size}"
# #     p "query(0.495) #{quantile_estimator.query(0.495)}"
# #     quantile_estimator.compress!
# #   end
# # end

# # p (1..10).to_a.shuffle
# test_values = [1, 4, 6, 5, 3, 10, 8, 9, 2, 7]
# test_values.each do |x|
#   quantile_estimator.insert(x)
# end

# quantile_estimator.samples.each {|x| p x}

# # p "size #{quantile_estimator.samples.size}"
# p "query(0.495) #{quantile_estimator.query(0.495)}"
# # p quantile_estimator.samples

# # quantile_estimator.compress!

# # p "size #{quantile_estimator.samples.size}"
# # p "query(0.495) #{quantile_estimator.query(0.495)}"
