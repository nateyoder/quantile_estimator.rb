# QuantileEstimator.rb

This implements the quantile estimator described in the paper:

Cormode et. al.:
"Effective Computation of Biased Quantiles over Data Streams"

Given the different strategies to implement the algorithm I used the easiest one by
using https://github.com/odo/quantile_estimator as reference for the implementation.


## Installation

Add this line to your application's Gemfile:

    gem 'quantile_estimator'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install quantile_estimator

## Usage

First initialize the estimator. Right now you can either have a `Biased` or
`Targeted` invariants. The targeted invariant let you select the quantiles you are
particularly interested and will yield higher compression rates.

    biased = Invariant::Biased.new(0.004)
    targeted = Invariant::Targeted.new([
                                        [0.05, 0.02],
                                        [0.5,  0.02],
                                        [0.95, 0.02]
                                       ])

    estimator = Estimator.new(targeted)

Insertion of data is as simple as:

    estimator.insert(value)

The insertion of data _doesn't_ automatically compress it. To compress the data just
call:

    estimator.compress!

Using these primitives you can build wraps to compress on every nth insert as shown
in
[this file](https://github.com/diegoeche/quantile_estimator.rb/blob/master/benchmark.rb)

## Pretty Graphs

Using a targeted invariant to keep track of the 0.05, 0.5 and 0.95 quantiles, a
uniform source of random values and compressing every 100 iterations. We get the
following behavior regarding the size of the internal data structure:

![compression rate (elements size, lower is better)](https://raw.github.com/diegoeche/quantile_estimator.rb/master/doc/compression.png
 "Elements in the estimator. Lower is better")

Running time behavior is not too bad. The following graph shows the cost of
insertions in the estimator. The homogeneous layer of outlayers probably corresponds
to the compression cycles, while the bottom line is the cost of compression-less
insertions.

![runtime behavior (ms, lower is better)](https://raw.github.com/diegoeche/quantile_estimator.rb/master/doc/time.png "Time in ms. Lower is better")

Different distributions, different invariants setups will have different behaviors.

Check your real data before using this!

## Known issues

The implementation is known not to be thread-safe, and little effort has been done to
optimize it.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
