# encoding: utf-8
require 'spec_helper'
module HardCiter
  describe Bibliography do

    let(:bibliography) { Bibliography.new }

    subject { :bibliography }

    describe "#pair_match_to_citation" do
      let(:line_num) { 3 }
      context "when the line number is 3" do
        context "when intext_match is of the type BIBLIOGRAPHY_OUT_MATCH" do
          before do
            @intext_match = IntextMatch.new
            @intext_match.type = HardCiter::BIBLIOGRAPHY_OUT_MATCH
            @result = bibliography.pair_match_to_citation(@intext_match,line_num)
          end
          it "should set its bib_out_line to the line number 3" do
            bibliography.bib_out_line.should == line_num
          end

          it "should set its bib_out_citation to the IntextMatch" do
            bibliography.bib_out_match.should be @intext_match
          end

          it "should return nil" do
            @result.should be_nil
          end
        end

        context "when intext_match is of the type INTEXT_CITATION_MATCH \
                 with a cite_key that exists in its citations " do
          let(:cite_key) { "xyz:123" }
          before do
            @citation = Citation.new(cite_key)
            bibliography.citations[cite_key] = @citation
            @intext_match = IntextMatch.new
            @intext_match.type = INTEXT_CITATION_MATCH
            @intext_match.regex_match = cite_key
          end

          it "should return the Citation from citations" do
            bibliography.pair_match_to_citation(@intext_match,line_num).should be @citation
          end
        end

        context "when intext_match is of the type INTEXT_CITATION_MATCH "+
                "with a cite_key that does not exist in citations"
        let(:cite_key) { "newkey:123"}
        before do
          @intext_match = IntextMatch.new
          @intext_match.type = INTEXT_CITATION_MATCH
          @intext_match.regex_match = cite_key
        end

        it "should return a new Citation" do
          bibliography.pair_match_to_citation(@intext_match,line_num).should be_kind_of(Citation)
        end
        it "should add the new Citation to its citations" do
          expect{bibliography.pair_match_to_citation(@intext_match,line_num)}.
          to change{bibliography.citations.length}.by(1)
        end
      end
    end

    describe "#add_citation" do
      context "when provided a intext_match" do
        before do
          bibliography.citations = {}
          @intext_match = IntextMatch.new
          @intext_match.regex_match = "text:123"
        end

        it "should add a citation to its citations" do
          expect{ bibliography.add_citation(@intext_match)}.
          to change{ bibliography.citations.length }.by(1)
        end

        it "should add a citation with the correct number" do
          bibliography.add_citation(@intext_match)
          bibliography.citations[@intext_match.cite_key].bib_number.should == 1
        end
      end
    end

    describe "#next_citation_index" do
      describe "should return the next available index in the citation list" do
        context "when the citation list is empty" do
          before { bibliography.citations = [] }
          it "should return 1" do
            bibliography.next_citation_index.should be 1
          end
        end
        context "when the citation list has 2 citations" do
          before { bibliography.citations = ["stub 1", "stub 2"] }
          it "should return 3" do
            bibliography.next_citation_index.should be 3
          end
        end
      end
    end
  end
end
