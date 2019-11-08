# frozen_string_literal: true

module Enumerable # rubocop:disable Metrics/ModuleLength
  # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  def my_each
    if block_given?
      v = self
      n = v.length
      n.times do |i|
        yield(v[i])
      end
    else
      to_enum(:my_each)
    end
  end

  def my_each_with_index
    if block_given?
      v = self
      n = v.length
      n.times do |i|
        yield(self[i], i)
      end
    else
      to_enum(:my_each_with_index)
    end
  end

  def my_select
    value = self
    if block_given?
      temp = []
      value.my_each do |a|
        temp.push(a) if yield(a)
      end
      temp
    else
      to_enum(:my_select)
    end
  end

  def my_all?(arg = nil)
    value = self
    if block_given?
      if value.is_a? Hash
        value.my_each { |a, b| return false unless yield(a, b) }
      else
        value.my_each { |a| return false unless yield(a) }
      end
    elsif arg.is_a? Regexp
      value.my_each { |a| return false unless a =~ arg }
    elsif arg.is_a? Class
      value.my_each { |a| return false unless a.class == arg }
    elsif arg.nil?
      value.my_each { |a| return false unless a }
    end
    true
  end

  def my_any?
    value = self
    if block_given?
      if value.is_a? Hash
        value.my_each { |a, b| return true if yield(a, b) }
      else
        value.my_each { |a| return true if yield(a) }
      end
    elsif arg.is_a? Regexp
      value.my_each { |a| return true if a =~ arg }
    elsif arg.is_a? Class
      value.my_each { |a| return true if a.class == arg }
    elsif arg.nil?
      value.my_each { |a| return true if a }
    end
    false
  end

  def my_none?
    value = self
    if block_given?
      if value.is_a? Hash
        value.my_each { |a, b| return false if yield(a, b) }
      else
        value.my_each { |a| return false if yield(a) }
      end
    elsif arg.is_a? Regexp
      value.my_each { |a| return false if a =~ arg }
    elsif arg.is_a? Class
      value.my_each { |a| return false if a.class == arg }
    elsif arg.nil?
      value.my_each { |a| return false if a }
    end
    true
  end

  def my_count(arg = nil)
    value = self
    count = 0
    if block_given?
      value.my_each do |a|
        count += 1 if yield(a)
      end
    end

    unless arg.nil?
      value.my_each do |a|
        count += 1 if arg == a
      end
    end

    count = value.length if !block_given? && arg.nil?
    count
  end

  def my_map(&block)
    arr = []
    value = self
    if block_given?
      if value.is_a? Hash
        value.my_each { |a, b| arr.push(block.call(a, b)) }
      elsif value.is_a? Array
        value.my_each { |a| arr.push(block.call(a)) }
      end
    else
      to_enum(:my_map)
    end
    arr
  end

  def my_inject(init = nil, arg = nil, &block)
    value = self
    sum
    if block_given?
      sum = init.nil? ? value[0] : init
      value.my_each_with_index { |a, i| sum = block.call(sum, a) unless i.zero? }
    elsif !init.nil? && arg.nil?
      if init.is_a? Symbol
        sum = value[0]
        value.my_each_with_index { |a, i| sum = sum.send(init, a) unless i.zero? }
      else
        sum = init
        value.my_each { |a| sum = block.call(sum, a) }
      end
    elsif !init.nil? && !arg.nil?
      sum = init
      value.my_each { |a| sum = sum.send(arg, a) }
    end
    sum
  end

  def multiply_els
    my_inject { |sum, result| sum + result }
  end
  # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
end

# [4, 7, 1].my_each { |a| puts a }
# [4, 7, 1].my_each_with_index { |_a, i| puts i }
# puts([4, 7, 1].my_select { |a| a > 1 })
# puts([4, 7, 1].my_all? { |a| a > 0 })
# puts([4, 7, 1].my_any? { |a| a == 0 })
# puts([4, 7, 1].my_none? { |a| a == 1 })
# puts([4, 7, 1].my_count(2))

# test = proc { |i| i + 2 }
# puts([4, 7, 1].my_map(& test))
# puts([4, 7, 1].my_map { |i| i + 2 })

# puts([1, 2, 3].multiply_els)
