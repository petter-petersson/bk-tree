require "spec"
require "../src/bk/node.cr"
require "../src/bk/tree.cr"

module SpecHelper
  def self.words
    Set(String).new(
      %w{Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
        incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud
        exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute
        irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla
        pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia
        deserunt mollit anim id est laborum}
    )
  end
end

class DistanceCalculatorMock
  include BK::WordDistanceCalculator
  property call_count : Int32 = 0
  property distance_values : Array(Int32) = (1..10).to_a
  property calls = [] of Tuple(String, String)

  def distance(string1 : String, string2 : String) : Int32
    @calls << {string1, string2}
    @call_count += 1
    return @distance_values[@call_count % @distance_values.size]
  end
end

class CallCountingDistanceCalculator < BK::LevenshteinDistanceCalculator
  property calls = [] of Tuple(String, String)

  def distance(string1 : String, string2 : String) : Int32
    @calls << {string1, string2}
    super
  end
end
