module Enumerable
  def my_each
    array = to_a
    index = 0
    while index <= array.size - 1
      yield(array[index])
      index += 1
    end
    array
  end

  def my_each_with_index
    index = 0
    my_each do |value|
      yield(value, index)
      index += 1
    end
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
      my_each { items_count += 1 if value == item }
    elsif block_given?
      my_each { items_count += 1 if yield(value) }
    else
      my_each { items_count += 1 }
    end
    items_count
  end

  def my_map
    if block_given?
      new_array = []
      my_each { |value| new_array << yield(value) }
      return new_array
    end
    to_enum
  end

  def my_inject(*args)
    array = to_a
    length = array.size

    if block_given?
      if args.size == 0
        memo = array[0]
        index = 1
      else
        memo = args[0]
        index = 0
      end

      while index < length
        memo = yield(memo, array[index])
        index += 1
      end

      return memo
    end

    if(args.size == 0)
      raise LocalJumpError.new('no block given')
    end

    if args.size == 2
      memo = args[0]
      sym = args[1]
      index = 0
    else
      memo = array[0]
      sym = args[0]
      index = 1
    end

    while index < length
      memo = memo.send(sym, array[index])
      index += 1
    end

    memo
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

puts "#{(5..10).my_inject(:+)} #=> 45"
puts "#{(5..10).my_inject { |sum, n| sum + n }} #=> 45"
puts "#{(5..10).my_inject(1, :*)} #=> 151200"
puts "#{(5..10).my_inject(1) { |product, n| product * n }} #=> 151200"
