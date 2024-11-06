require "levenshtein"

module BK
  module WordDistanceCalculator
    def distance(string1 : String, string2 : String) : Int32
      raise "abstract"
    end
  end

  class LevenshteinDistanceCalculator
    include BK::WordDistanceCalculator

    def distance(string1 : String, string2 : String) : Int32
      return Levenshtein.distance(string1, string2)
    end
  end

  class Node
    property word : String
    property distance_calculator : WordDistanceCalculator
    property children : Hash(Int32, Node)

    def initialize(word : String, distance_calculator : WordDistanceCalculator)
      @word = word
      @distance_calculator = distance_calculator
      @children = Hash(Int32, Node).new
    end

    def add(word : String)
      distance = @distance_calculator.distance(word, self.word)
      if children.has_key?(distance)
        child = children[distance]
        child.add(word)
      else
        children[distance] = Node.new(word, @distance_calculator)
      end
    end

    def query(word : String, threshold : Int32, result : Hash(Int32, String))
      distance_at_node = @distance_calculator.distance(word, self.word)
      result[distance_at_node] = self.word if distance_at_node <= threshold
      (-threshold..threshold).each do |d|
        next unless children.has_key?(distance_at_node + d)
        child = children[distance_at_node + d]
        child.query(word, threshold, result)
      end
    end
  end
end
