require "../spec_helper"

describe BK::Node do
  context "adding and querying" do

    it "should locate similar item" do
      distance_calculator = SpecHelper::DistanceCalculator.new
      list = SpecHelper.words.to_a
      root = BK::Node.new(list.first, distance_calculator)
      list[1..-1].each do |word|
        root.add(word.downcase.gsub(/[^a-z]+/, ""))
      end
      distance_calculator.calls.clear

      result = Hash(Int32, String).new
      root.query("feniam", 1, result)
      distance_calculator.calls.size.should eq(24)
      result.should eq(
        {1 => "veniam"}
      )
    end

    context "on a large data set" do
      it "should locate similar items" do
        distance_calculator = SpecHelper::DistanceCalculator.new
        root : BK::Node? = nil
        row = 0
        t = Time.measure do
          File.each_line("/usr/share/dict/words") do |word|
            case {row += 1, root}
            when {1, nil}
              root = BK::Node.new(word.downcase.gsub(/[^a-z]+/, ""), distance_calculator)
            when {.>(1), _}
              root.not_nil!.add(word.downcase.gsub(/[^a-z]+/, ""))
            end
          end
          distance_calculator.calls.clear
        end
        puts t

        result = Hash(Int32, String).new
        t = Time.measure do
          root.not_nil!.query("aproksimation", 4, result)
        end
        puts t
        result.should eq(
          {4 => "approximations", 3 => "approximation"}
        )
        distance_calculator.calls.size.should eq(20977)
      end
    end
  end
end
