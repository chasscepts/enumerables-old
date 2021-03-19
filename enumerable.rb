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

  def my_all(pattern = nil)
    if block_given?
      my_each { |value| return false unless yield(value) }
      return true
    end
    unless pattern.nil
      my_each { |value| return false unless match_pattern(value, pattern) }
      return true
    end
    my_each { |value| return false unless value }
    true
  end

  def my_any?(pattern = nil)
    if block_given?
      my_each { |item| return true if yield(item) }
      return false
    end
    unless pattern.nil?
      my_each { |item| return true if match_pattern(item, pattern) }
      return false
    end
    my_each { |item| return true if item }
    false
  end

  def my_none?(pattern = nil)
    if block_given?
      my_each { |value| return false if yield(value) }
      true
    end
    unless pattern.nil?
      my_each { |value| return false if match_pattern(value, pattern) }
      true
    end
    my_each { |_value| return false if item }
    true
  end

  def my_count(item = nil)
    items_count = 0
    if !item.nil?
      my_each { |value| items_count += 1 if value == item }
    elsif block_given?
      my_each { |value| items_count += 1 if yield(value) }
    else
      my_each { |value| items_count += 1 }
    end
    items_count
  end

  private

  def match_pattern(item, pattern)
    return true if item == pattern || item =~ pattern

    begin
      return true if item.is_a?(pattern)
    rescue TypeError
      return false
    end
    false
  end
end

ary = [1, 2, 4, 2]
puts "#{ary.my_count} #=> 4"
puts "#{ary.my_count(2)} #=> 2"
puts "#{ary.my_count{ |x| x%2==0 }} #=> 3"
