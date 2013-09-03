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
  end
end

#Group matches spec old


#describe HardCiter, "#group_matches" do
#  let(:hard_citer){ HardCiter.new }
#  let(:two_paired_matches_line) { "This sentence has two citations at the end{Biswal:2010fj}{Davis:2003wp}." }
#  let(:two_unpaired_matches_line) { "This sentence has two unpaired{Biswal:2010fj} citations{Davis:2003wp}." }
#  let(:one_separate_one_pair_line) { "This sentence has two paired citations{Davis:2003wp}{Biswal:2010fj} and "+
#                                    "a lone citation{Jones:1999qs}." }
#  let(:biswal_citation) { CiteMatch.new("{Biswal:2010fj}") }
#  let(:jones_citation) { CiteMatch.new("{Jones:1999qs}") }
#  let(:davis_citation) { CiteMatch.new("{Davis:2003wp}") }
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