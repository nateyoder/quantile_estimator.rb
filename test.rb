# require "quantile"
require "quantile_estimator"
require "item"
require "invariant"

# quantile = Quantile.new
# quantile.quantile, quantile.error = 0.90, 0.001

invariant = BiasedInvariant.new(0.0001)
quantile_estimator = QuantileEstimator.new(invariant)

items =

(1..100).each do |x|
  quantile_estimator.insert((1..1000).to_a[(rand * 100).floor])
  if x % 10 == 1
    p "size #{quantile_estimator.samples.size}"
    p "query(0.495) #{quantile_estimator.query(0.495)}"
    quantile_estimator.compress!
  end
end

# 100.times do
#   quantile_estimator.compress!
# end

p "size #{quantile_estimator.samples.size}"
p "query(0.495) #{quantile_estimator.query(0.495)}"
