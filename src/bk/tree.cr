require "levenshtein"
require "./node.cr"

module BK
  class Tree
    private property root : Node?

    def initialize(distance_calculator = BK::LevenshteinDistanceCalculator.new)
      @distance_calculator = distance_calculator
    end

    def add(word : String)
      if @root.nil?
        @root = Node.new(word, @distance_calculator)
      else
        @root.not_nil!.add(word)
      end
    end

    def query(word : String, threshold : Int32) : Hash(Int32, String)
      result = Hash(Int32, String).new
      @root.not_nil!.query(word, threshold, result) unless @root.nil?
      return result
    end

    def to_h
      aggregate = Hash(Int32, Array(String)).new
      unless @root.nil?
        traverse(@root.not_nil!, 0, aggregate)
      end
      aggregate
    end

    private def traverse(
      node : BK::Node,
      score : Int32,
      aggregate : Hash(Int32, Array(String))
    )
      unless aggregate.has_key?(score)
        aggregate[score] = [] of String
      end
      aggregate[score] << node.word

      node.children.each do |score, child|
        traverse(child, score, aggregate)
      end
    end

  end
end
