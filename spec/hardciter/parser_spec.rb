# encoding: utf-8
require 'spec_helper'

module HardCiter
  describe Parser do
    let(:parser) { Parser.new() }
    let(:default_bib_key) { HardCiter.configuration.bibliography_key }
    let(:default_bib_string) { "{papers2_bibliography}" }
    let(:default_citation_key) { HardCiter.configuration.citation_key }

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
        it "should return nil" do
          result = parser.parse_line(@no_intext_citations)
          result.should be_nil
        end
      end

      context "with line that has a bibliography key starting at the 3rd char" do
        before do
          bib_line = "012"+default_bib_string
          @result = parser.parse_line(bib_line)
        end
        it "should return an IntextMatch" do
          @result.should be_a_kind_of(HardCiter::IntextMatch)
        end
        it "should return an IntextMatch with a type of bibliography" do
          @result.type.should be HardCiter::BIBLIOGRAPHY_OUT_MATCH
        end
        it "should return an IntextMatch with position 3" do 
          @result.position.should be 3
        end
      end
    end
  end
end