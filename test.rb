# require "quantile"
require "quantile_estimator"
require "item"
require "invariant"

# quantile = Quantile.new
# quantile.quantile, quantile.error = 0.90, 0.001

invariant = BiasedInvariant.new(0.001)
quantile_estimator = QuantileEstimator.new(invariant)



(1..1000).each do |x|
  quantile_estimator.insert(rand)
end


# p quantile_estimator.samples
p quantile_estimator.query(0.495)
