require "../spec_helper"

describe BK::Tree do
  context "#query" do
    it "should retreive expected items" do
      tree = BK::Tree.new
      SpecHelper.words.each do |word|
        tree.add(word)
      end

      tree.query("comudo", 2).should eq(
        {2 => "commodo"}
      )
    end

    it "should not return anything if empty" do
      tree = BK::Tree.new
      tree.query("Lorem", 10).should be_empty
    end
  end

  context "#to_h" do
    it "should return a hash" do
      tree = BK::Tree.new
      SpecHelper.words.each do |word|
        tree.add(word)
      end

      result = tree.to_h

      result.should eq(
        {0 => ["Lorem"],
         4 => ["ipsum", "non", "sed", "enim", "amet,", "quis", "nulla"],
         5 => ["dolor", "et", "minim", "irure", "sit", "ad", "magna",
               "fugiat", "commodo"],
         3 => ["do", "aute", "esse", "dolore", "elit,", "nisi", "sunt", "est"],
         1 => ["ex", "ea", "anim", "Duis", "Ut", "id", "sint"],
         7 => ["laborum", "aliqua.", "occaecat", "deserunt", "voluptate"],
         2 => ["eu", "qui", "velit", "ut", "in", "culpa", "aliquip"],
         6 => ["labore", "mollit", "cillum", "nostrud", "laboris", "eiusmod",
               "tempor", "veniam,", "ullamco", "officia"],
         9 => ["consectetur", "Excepteur"],
         8 => ["cupidatat", "incididunt", "proident,", "consequat.", "pariatur."],
         10 => ["adipiscing"], 11 => ["exercitation", "reprehenderit"]}
      )
    end
  end
end
