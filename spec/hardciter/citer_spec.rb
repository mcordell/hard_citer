# encoding: utf-8
require 'spec_helper'

module HardCiter
  describe Citer do
    let(:citer) { Citer.new }
    let(:valid_path) { File.expand_path('../../../examples/example_bib.bib', __FILE__) }

    subject { citer }

    it { should respond_to :library }
    it { should respond_to :bibliography }
    it { should respond_to :styler }

    describe '#initialize_library_by_path' do
      context "path is a valid file ending in Bibtex's .bib extension" do
        it 'should set its bibliography to a BibtexLibrary' do
          citer.initialize_library_by_path(valid_path)
          citer.library.should be_kind_of(BibTexLibrary)
        end
      end
    end

    describe "#validate_prerequisites" do
      context "when library is nil" do
        before { citer.library = nil }
        it "should raise an error" do
          expect { citer.validate_prerequisites}.
          to raise_error(StandardError, 'Library missing cannot proceed with citation')
        end
      end
      context "when csl is nil" do
        before do 
          citer.initialize_library_by_path(valid_path)
          citer.csl = nil
        end
        it "should raise an error" do
          expect { citer.validate_prerequisites}.
          to raise_error(StandardError, 'No citation format found, cannot proceed with citation')
        end
      end
    end

    describe "#group_matches!" do
      context "with a line has one match that follows another" do
        before do
          @line = "{match:one}{match:two}"
          @matches = Parser.new.parse_line(@line)
          @first_match = @matches[0]
          @second_match = @matches[1]
          citer.group_matches!(@matches, @line)
        end

        describe "moves the trailing match to the leading match's next_in_group" do
          it "should add the trailing match to leading match's next_in_group" do
            @first_match.next_in_group.should be @second_match
          end
          it "should delete the second match from the matches" do
            @matches.should_not include(@second_match)
          end
        end
      end

      context "with a line that has one match that follows another with white space" do
        before do
          @line = "{match:one} {match:two}"
          @matches = Parser.new.parse_line(@line)
          @first_match = @matches[0]
          @second_match = @matches[1]
          citer.group_matches!(@matches, @line)
        end
        describe "moves the trailing match to the leading match's next_in_group" do
          it "should add the trailing match to leading match's next_in_group" do
            @first_match.next_in_group.should be @second_match
          end
          it "should delete the second match from the matches" do
            @matches.should_not include(@second_match)
          end
        end
      end

      context "with a line that has three matches in a row" do
        before do
          @line = "{match:one}{match:two}{match:three}"
          @matches = Parser.new.parse_line(@line)
          @first_match = @matches[0]
          @second_match = @matches[1]
          @third_match = @matches[2]
          citer.group_matches!(@matches, @line)
        end
        describe "moves the trailing match to the leading match's next_in_group" do
          it "should add the second match to leading match's next_in_group" do
            @first_match.next_in_group.should be @second_match
          end
          it "should add the third match to second match's next_in_group" do
            @second_match.next_in_group.should be @third_match
          end
          it "should leave the first_match in the matches array" do
            @matches.should include (@first_match)
          end
          it "should delete the second and third match from the matches" do
            @matches.should_not include(@second_match)
            @matches.should_not include(@third_match)
          end
        end
      end

      context "with a line that has three matches, with two in a row" do
        before do
          @line = "{match:one}{match:two} something that is not a citation {match:three}"
          @matches = Parser.new.parse_line(@line)
          @first_match = @matches[0]
          @second_match = @matches[1]
          @third_match = @matches[2]
          citer.group_matches!(@matches, @line)
        end
        describe "moves the trailing match to the leading match's next_in_group" do
          it "should add the second match to leading match's next_in_group" do
            @first_match.next_in_group.should be @second_match
          end
          it "should delete the second match from the matches" do
            @matches.should_not include(@second_match)
          end
          it "should not delete the third match from matches" do
            @matches.should include(@third_match)
          end
        end
      end
    end
  end
end

#Group matches spec old


#describe HardCiter, "#group_matches" do
#  let(:hard_citer){ HardCiter.new }
#  let(:two_paired_matches_line) { "This sentence has two citations at the end{Biswal:2010fj}{Davis:2003wp}." }
#  let(:two_unpaired_matches_line) { "This sentence has two unpaired{Biswal:2010fj} citations{Davis:2003wp}." }
#  let(:one_separate_one_pair_line) { "This sentence has two paired citations{Davis:2003wp}{Biswal:2010fj} and "+
#                                    "a lone citation{Jones:1999qs}." }
#  let(:biswal_citation) { Citation.new("{Biswal:2010fj}") }
#  let(:jones_citation) { Citation.new("{Jones:1999qs}") }
#  let(:davis_citation) { Citation.new("{Davis:2003wp}") }
#
#  describe "when given a line with two matches not next to each other" do
#    it "should return an array with two elements (one for each match)" do
#      matches = [[biswal_citation, 30], [davis_citation, 55]]
#      pairing_result = hard_citer.group_matches(matches, two_unpaired_matches_line)
#      pairing_result.should == [[biswal_citation, 30], [davis_citation, 55]]
#    end
#  end
#  describe "when given a line with two matches next to each other" do
#    it "should return an array with one element: an array of the two matches" do
#      matches = [[biswal_citation, 42], [davis_citation, 57]]
#      pairing_result = hard_citer.group_matches(matches, two_paired_matches_line)
#      pairing_result.should == [[[biswal_citation, 42], [davis_citation, 57]]]
#    end
#  end
#  describe "when given a line with one pair of matches and one lone match" do
#    it "should return an array with two elements: an array of the two matches, and the lone match" do
#      matches = [[davis_citation, 38], [biswal_citation, 52], [jones_citation, 87]]
#      pairing_result = hard_citer.group_matches(matches, one_separate_one_pair_line)
#      pairing_result.should == [[[davis_citation, 38], [biswal_citation, 52]], [jones_citation, 87]]
#    end
#  end
#end