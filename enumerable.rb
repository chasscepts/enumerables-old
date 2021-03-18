module Enumerable
  def my_each
    index = 0
    while index <= self.size - 1
      yield(self[index])
      index += 1
    end
    self
  end

  def my_each_with_index
    index = 0
    self.my_each do |value|
      yield(value, index)
      index += 1
    end
    self
  end
end

[1, 2, 3, 4].my_each_with_index { |a, b| puts "#{b} =#{a}" }
