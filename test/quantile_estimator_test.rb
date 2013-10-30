# require 'test/unit'
# # require 'quantile_estimator'

# class QuantileEstimatorTest < Test::Unit::TestCase
#   def test_it_loads
#     invariant = BiasedInvariant.new(0.00001)
#     quantile_estimator = QuantileEstimator.new(invariant)

#     puts "It Loads?"
#   end
# end

# # require "rubygems"
# # require "quantile_estimator"
# # require "item"
# # require "invariant"

# # # quantile = Quantile.new
# # # quantile.quantile, quantile.error = 0.90, 0.001

# # invariant = BiasedInvariant.new(0.00001)
# # quantile_estimator = QuantileEstimator.new(invariant)

# # # (1..1000).each do |x|
# # #   # quantile_estimator.insert((1..1000).to_a[(rand * 100).floor])
# # #   quantile_estimator.insert(rand)
# # #   if x % 50 == 1
# # #     p "size #{quantile_estimator.samples.size}"
# # #     p "query(0.495) #{quantile_estimator.query(0.495)}"
# # #     quantile_estimator.compress!
# # #   end
# # # end

# # # p (1..10).to_a.shuffle
# # test_values = [1, 4, 6, 5, 3, 10, 8, 9, 2, 7]
# # test_values.each do |x|
# #   quantile_estimator.insert(x)
# # end

# # quantile_estimator.samples.each {|x| p x}

# # # p "size #{quantile_estimator.samples.size}"
# # p "query(0.495) #{quantile_estimator.query(0.495)}"
# # # p quantile_estimator.samples

# # # quantile_estimator.compress!

# # # p "size #{quantile_estimator.samples.size}"
# # # p "query(0.495) #{quantile_estimator.query(0.495)}"
