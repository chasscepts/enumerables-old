module Enumerable
  public

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
    all = true
    if block_given?
      my_each do |value|
        if !yield(value)
          all = false
        end
      end
    elsif !pattern.nil?
      my_each do |value|
        if !match_pattern(value, pattern)
          all = false
        end
      end
    else
      my_each do |value|
        if !value
          all = false
        end
      end
    end
    all
  end

  def my_any?(pattern = nil)
    if block_given?
      my_each { |item| return true if yield(item) }
      return false
    end
    if !pattern.nil?
      my_each { |item| return true if match_pattern(item, pattern) }
      return false
    end
    my_each { |item| return true if item }
    false
  end

  private

  def match_pattern(item, pattern)
    return true if item == pattern || item =~ pattern
    begin
      return true if item.is_a?(pattern)
    rescue TypeError => exception;     end
    false
  end
end
