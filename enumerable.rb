# frozen_string_literal: true

module Enumerable # rubocop:disable Metrics/ModuleLength
  def my_each
    n = self.length
    n.times do |i|
      yield(self[i])
    end
  end

  def my_each_with_index(arr)
    n = arr.length
    n.times do |i|
      yield(arr[i], i)
    end
  end

  def my_select(arr)
    temp = []
    my_each(arr) do |a|
      temp.push(a) if yield(a)
    end
    temp
  end

  def my_all?(arr)
    my_each(arr) do |a|
      return false unless yield(a)
    end
    true
  end

  def my_any?(arr)
    my_each(arr) do |a|
      return true if yield(a)
    end
    false
  end

  def my_none?(arr)
    my_each(arr) do |a|
      return false if yield(a)
    end
    true
  end

  def my_count(arr, condition = nil) # rubocop:disable  Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    count = 0
    if block_given?
      my_each(arr) do |a|
        count += 1 if yield(a)
      end
    end

    unless condition.nil?
      my_each(arr) do |a|
        count += 1 if condition == a
      end
    end

    count = arr.length if !block_given? && condition.nil?
    count
  end

  def my_map
    #code
  end

  def my_inject
    #code
  end
end

include Enumerable

puts [4, 7, 1].my_each { |a| puts a }