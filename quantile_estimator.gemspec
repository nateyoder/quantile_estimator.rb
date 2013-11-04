# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'quantile_estimator/version'

Gem::Specification.new do |spec|
  spec.name          = "quantile_estimator"
  spec.version       = QuantileEstimator::VERSION
  spec.authors       = ["Diego Echeverri"]
  spec.email         = ["diegoeche@gmail.com"]
  spec.description   = %q{
    Implementation of quantile estimators based on.

    Cormode et. al.: "Effective Computation of Biased Quantiles over Data Streams"
  }
  spec.summary       = %q{
    This gem implements a simple quantile estimator using Ruby Arrays.
  }
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib", "lib/quantile_estimator"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
