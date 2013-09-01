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
      create_match(match_data, HardCiter::BIBLIOGRAPHY_OUT_MATCH)
    end

    def create_citation_match(match_data)
      create_match(match_data, HardCiter::INTEXT_CITATION_MATCH)
    end

    def create_match(match_data,type)
      match = HardCiter::IntextMatch.new()
      match.position = match_data.begin(0) 
      match.type = type
      match.regex_match = match_data.to_s
      match
    end

    def find_intext_citations(line)
      line.enum_for(:scan, @citation_key).map do
        create_citation_match(Regexp.last_match)
      end
    end

    def parse_line(line)
      if has_bibliography_key?(line)
        [create_bib_match(line)]
      else
        find_intext_citations(line)
      end
    end
  end
end