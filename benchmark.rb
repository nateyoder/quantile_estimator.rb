require 'estimator'

biased = Invariant::Biased.new(0.004)
targeted = Invariant::Targeted.new([
                                    [0.05, 0.02],
                                    [0.5,  0.02],
                                    [0.95, 0.02]
                                   ])

# estimator = Estimator.new(invariant)

estimator = Estimator.new(targeted)

10000.times do |i|
  nowish = Time.now.to_f
  estimator.insert(rand)
  if i % 100 == 99
    estimator.compress!
  end
  puts [i, 1000 * (Time.now.to_f - nowish), estimator.samples.size].join("\t")
end
