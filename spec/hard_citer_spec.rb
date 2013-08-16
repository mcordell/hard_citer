##This file is like a giant integration test that is left over from before
#HardCiter was a proper module
#TODO: Needs to be refactored to either use the module or broken up into smaller
#tests
require 'spec_helper'
require_relative '../lib/hard_citer'
require_relative '../lib/cite_match'

describe HardCiter, "#parse_sentence" do
    let(:hard_citer){ HardCiter.new }
    describe "parsing a sentence with a reference" do
      it "should return the location pair" do
        parse_result = hard_citer.parse_line "Hey man this is a sentence with a citation at the end {Wasmuth:2000vy}."
        parse_result.should == [['{Wasmuth:2000vy}', 54]]
      end
    end

    describe "parsing a sentence without a refrence" do
      it "should return an empty array" do
        parse_result = hard_citer.parse_line "Hey man this is a sentence without a citation at the end." 
        parse_result.should be_empty
      end
    end

    describe "the parse_line function with multiple references" do
      it "should return an array with two location pairs in it" do
        parse_result = hard_citer.parse_line("This sentence has two citations at the end{Biswal:2010fj}{Davis:2003wp}.")
        parse_result.should == [["{Biswal:2010fj}", 42], ["{Davis:2003wp}", 57]]
      end
    end
end

describe HardCiter, "#group_matches" do
  let(:hard_citer){ HardCiter.new }
  let(:two_paired_matches_line) { "This sentence has two citations at the end{Biswal:2010fj}{Davis:2003wp}." }
  let(:two_unpaired_matches_line) { "This sentence has two unpaired{Biswal:2010fj} citations{Davis:2003wp}." }
  let(:one_separate_one_pair_line) { "This sentence has two paired citations{Davis:2003wp}{Biswal:2010fj} and "+
                                    "a lone citation{Jones:1999qs}." }
  let(:biswal_citation) { CiteMatch.new("{Biswal:2010fj}") }
  let(:jones_citation) { CiteMatch.new("{Jones:1999qs}") }
  let(:davis_citation) { CiteMatch.new("{Davis:2003wp}") }

  describe "when given a line with two matches not next to each other" do
    it "should return an array with two elements (one for each match)" do
      matches = [[biswal_citation, 30], [davis_citation, 55]]
      pairing_result = hard_citer.group_matches(matches, two_unpaired_matches_line)
      pairing_result.should == [[biswal_citation, 30], [davis_citation, 55]]
    end
  end
  describe "when given a line with two matches next to each other" do
    it "should return an array with one element: an array of the two matches" do
      matches = [[biswal_citation, 42], [davis_citation, 57]]
      pairing_result = hard_citer.group_matches(matches, two_paired_matches_line)
      pairing_result.should == [[[biswal_citation, 42], [davis_citation, 57]]]
    end
  end
  describe "when given a line with one pair of matches and one lone match" do
    it "should return an array with two elements: an array of the two matches, and the lone match" do
      matches = [[davis_citation, 38], [biswal_citation, 52], [jones_citation, 87]]
      pairing_result = hard_citer.group_matches(matches, one_separate_one_pair_line)
      pairing_result.should == [[[davis_citation, 38], [biswal_citation, 52]], [jones_citation, 87]]
    end
  end
end
