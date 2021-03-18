module Enumerable
  def my_each
    index = 0
    while index <= size - 1
      yield(self[index])
      index += 1
    end
    self
  end

  def my_each_with_index
    index = 0
    my_each do |value|
      yield(value, index)
      index += 1
    end
    self
  end

  def my_select
    result = []
    my_each { |item| result << item if yield item }
    result
  end
end
