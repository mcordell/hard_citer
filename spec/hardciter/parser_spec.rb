# encoding: utf-8
require 'spec_helper'

module HardCiter
  describe Parser do
    let(:parser) { Parser.new() }

    describe "initialization" do 
      context "when bibkey is not provided" do 
        it "should set its bibkey to the default configuration" do 
          default_bibliography_key = HardCiter.configuration.bibliography_key
          parser.bib_key.should be default_bibliography_key
        end
      end
      context "when intext_key is not provided" do 
        it "should set its intext_key to the default configuration" do 
          default_citation_key = HardCiter.configuration.citation_key
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

      context "line has key that matches bibliography output" do
        it "should return an IntextMatch with that position"
      end
    end
  end
end