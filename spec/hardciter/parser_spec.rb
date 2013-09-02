# encoding: utf-8
require 'spec_helper'

module HardCiter
  describe Parser do
    let(:parser) { Parser.new() }
    let(:default_bib_key) { HardCiter.configuration.bibliography_pattern }
    let(:default_citation_key) { HardCiter.configuration.intext_pattern }
    let(:bib_key_example) { "{papers2_bibliography}" }
    let(:citation_key_example) { "{charles:19jk}" }

    describe "initialization" do 
      context "when bibkey is not provided" do 
        it "should set its bibkey to the default configuration" do 
          parser.bib_key.should be default_bib_key
        end
      end
      context "when intext_key is not provided" do 
        it "should set its intext_key to the default configuration" do 
          parser.citation_key.should be default_citation_key
        end
      end
      context "when intext_key provided" do
        it "should set its citation_key to that regex" do
          citation_key_pattern = /\[pattern\]/
          new_parser = Parser.new(nil,citation_key_pattern)
          new_parser.citation_key.should be citation_key_pattern
        end
      end
      context "when bib_key provided" do
        it "should set its bib_key to that regex" do
          bib_key_pattern = /\[pattern\]/
          new_parser = Parser.new(bib_key_pattern)
          new_parser.bib_key.should be bib_key_pattern
        end
      end
    end

    describe "#parse_line" do
      context "no in text citations in line" do
        before do
          @no_intext_citations = "this line has no intext citations"
        end
        it "should return an empty array" do
          result = parser.parse_line(@no_intext_citations)
          result.should be_empty
        end
      end

      context "with line that has a bibliography key starting at the 3rd position" do
        before do
          bib_line = "012"+bib_key_example
          @result = parser.parse_line(bib_line)
        end
        it "should return an array with an IntextMatch" do
          @result[0].should be_a_kind_of(HardCiter::IntextMatch)
        end
        it "should return an IntextMatch with a type of bibliography" do
          @result[0].type.should be HardCiter::BIBLIOGRAPHY_OUT_MATCH
        end
        it "should return an IntextMatch with position 3" do 
          @result[0].position.should be 3
        end
      end

      context "with line that has an in-text citation at the 5th position" do
        before do 
          bib_line = "01234"+citation_key_example
          @result = parser.parse_line(bib_line)
        end
        it "should return an array with an IntextMatch" do
          @result[0].should be_a_kind_of(HardCiter::IntextMatch)
        end
        it "should return an IntextMatch with a type of intext citation" do
          @result[0].type.should be HardCiter::INTEXT_CITATION_MATCH
        end
        it "should return an IntextMatch with position 3" do 
          @result[0].position.should be 5
        end
      end

      context "with line that has multiple citations" do
        before do
          multi_line = "01234{678:01}23{second:123}"
          @result = parser.parse_line(multi_line)
        end
        it "should return an array with two intext-citations" do 
          @result.length.should eq 2
          @result.each { |r| r.should be_a_kind_of(HardCiter::IntextMatch) }
        end
        it "should return the first citation as the first intext" do
          @result[0].regex_match.should eq "{678:01}"
          @result[0].position.should be 5
        end
        it "should return the second citation as the second intext" do
          @result[1].regex_match.should eq "{second:123}"
          @result[1].position.should be 15 
        end
      end
    end
  end
end