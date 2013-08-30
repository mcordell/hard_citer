# encoding: utf-8
module HardCiter
  class Parser
    attr_accessor :bib_key, :citation_key

    def initialize(bib_key=nil,citation_key=nil)
      @bib_key = bib_key ? bib_key : HardCiter.configuration.bibliography_key
      @citation_key = citation_key ? citation_key : HardCiter.configuration.citation_key
    end
    
    def has_bibliography_key?(line)
      line =~ @bib_key
    end

    def create_bib_match(line)
      match_data = @bib_key.match(line)
      match = HardCiter::IntextMatch.new()
      match.type = HardCiter::BIBLIOGRAPHY_OUT_MATCH
      match.position = match_data.begin(0) 
      match.regex_match = match_data.to_s
      match
    end

    def find_intext_citations(line)
      nil
    end

    def parse_line(line)
      if has_bibliography_key?(line)
        create_bib_match(line)
      else
        find_intext_citations(line)
      end
    end
  end
end