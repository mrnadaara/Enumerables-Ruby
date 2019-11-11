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
    else
      value.my_each { |a| return false unless a == arg }
    end
    true
  end

  def my_any?(arg = nil)
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
    else
      value.my_each { |a| return true if a == arg }
    end
    false
  end

  def my_none?(arg = nil)
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
    else
      value.my_each { |a| return false if a == arg }
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
      arr
    else
      to_enum(:my_map)
    end
  end

  def my_inject(init = nil, arg = nil, &block)
    value = self
    value = value.dup.to_a
    accum = init
    if block_given?
      accum = init.nil? ? value.shift : init
      value.my_each { |a| accum = block.call(accum, a) }
    elsif !init.nil? && arg.nil?
      if init.is_a? Symbol
        accum = value.shift
        value.my_each { |a| accum = accum.send(init, a) }
      else
        accum = init
        value.my_each { |a| accum = block.call(accum, a) }
      end
    elsif !init.nil? && !arg.nil?
      accum = init
      value.my_each { |a| accum = accum.send(arg, a) }
    end
    accum
  end
  # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
end

def multiply_els(arg)
  arg.my_inject { |sum, result| sum * result }
end

# puts(multiply_els((1...4)))
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
