module Enumerable
  def my_each
    index = 0
    while index <= self.size - 1
      yield(self[index])
      index += 1
    end
    self
  end
end

puts [1, 2, 3, 4].my_each { }
