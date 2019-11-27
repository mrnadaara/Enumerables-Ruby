# frozen_string_literal: true

# ./spec/enum_spec.rb

require_relative '../enumerable'

RSpec.describe 'Enum' do
  describe '#any?' do
    it 'checks if value passed is contained in a variable' do
      expect([4, 7, 0].my_any? { |a| a == 0 }).to eql(true)
    end
    it 'checks if value passed is contained in a variable' do
      expect([].my_any? { |a| a == 0 }).to eql(false)
    end
  end
  describe '#all?' do
    it 'checks if value passed is equal to all values in a variable' do
      expect([4, 7, 1].my_all? { |a| a > 0 }).to eql(true)
    end
    it 'checks if value passed is equal to all values in a variable' do
      expect([-1, -3, 0].my_all? { |a| a > 0 }).to eql(false)
    end
  end
  describe '#none?' do
    it 'checks if value passed is not equal to any values in a variable' do
      expect([4, 7, 1].my_none? { |a| a == 1 }).to eql(false)
    end
    it 'checks if value passed is not equal to any values in a variable' do
      expect([].my_none? { |a| a == 1 }).to eql(true)
    end
  end
  describe '#count?' do
    it 'returns length of value passed or returns number of variables that passes a condition ' do
      expect([4, 7, 1].my_count).to eql(3)
    end
    it 'returns length of value passed or returns number of variables that passes a condition ' do
      expect([].my_count).to eql(0)
    end
  end
  describe '#select?' do
    it 'returns values of passed variable that passes a condition ' do
      expect([4, 7, 1].my_select { |a| a > 1 }).to eql([4, 7])
    end
    it 'returns values of passed variable that passes a condition ' do
      expect([].my_select { |a| a > 1 }).to eql([])
    end
  end
  describe '#inject?' do
    it 'returns accumulated value of passed variable ' do
      expect([4, 7, 1].my_inject { |sum, result| sum + result }).to eql(12)
    end
    it 'returns accumulated value of passed variable ' do
      expect([].my_inject { |sum, result| sum + result }).to eql(nil)
    end
  end
end
