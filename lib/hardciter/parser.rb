# encoding: utf-8
module HardCiter
  class Parser
    attr_accessor :bib_key_pattern, :citation_key_pattern

    def initialize(bib_key_pattern=nil,citation_key_pattern=nil)
      @bib_key_pattern = bib_key_pattern ? bib_key_pattern : HardCiter.configuration.bibliography_pattern
      @citation_key_pattern = citation_key_pattern ? citation_key_pattern : HardCiter.configuration.intext_pattern
    end
    
    def has_bibliography_key?(line)
      line =~ @bib_key_pattern
    end

    def create_bib_match(line)
      match_data = @bib_key_pattern.match(line)
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
      line.enum_for(:scan, @citation_key_pattern).map do
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