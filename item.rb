# n = items
# k = asymptote
# S = data structure containing multiple tuples
# s = samples of items from the data stream
class Item
  attr_accessor :value, :g, :delta, :rank
  def initialize(value, g, delta, rank=0)
    self.value = value
    self.g = g
    self.delta = delta
    self.rank  = rank
  end

  def merge(item)
    Item.new(item.value, self.g + item.g, item.delta)
  end
end
