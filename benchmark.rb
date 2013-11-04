require 'estimator'

invariant = Invariant::Biased.new(0.004)
estimator = Estimator.new(invariant)


10000.times do |i|
  nowish = Time.now.to_f
  estimator.insert(rand)
  if i % 100 == 99
    estimator.compress!
  end
  puts [i, Time.now.to_f - nowish, estimator.samples.size].join("\t")
end
