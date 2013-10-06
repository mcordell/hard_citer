module HardCiter
  class Bibliography
    attr_accessor :bibliography_intext, :intext_regex, :bib_out_line, :bib_out_match,
                  :citation_locations, :citations, :bit_out_location

    def initialize
      @bibliography_intext = HardCiter.configuration.bibliography_pattern
      @intext_regex = HardCiter.configuration.intext_pattern
      @citation_locations = {}
      @citations = {}
    end

    def pair_match_to_citation(intext_match,line_num)
      if intext_match.type == HardCiter::BIBLIOGRAPHY_OUT_MATCH
        set_bib_out(intext_match,line_num)
        nil
      else
        get_or_create_citation(intext_match)
      end
    end

    def set_bib_out(intext_match,line_num)
      @bib_out_line = line_num
      @bib_out_match = intext_match
    end

    def get_or_create_citation(intext_match)
      if @citations.has_key?(intext_match.cite_key)
        @citations[intext_match.cite_key]
      else
        add_citation(intext_match)
      end
    end

    def has_bibliography_key?(line)
      line =~ @bibliography_intext
    end

    def add_citation(intext_match)
      citation = HardCiter::Citation.new(intext_match.cite_key)
      citation.bib_number = next_citation_index
      @citations[citation.key] = citation
      citation
    end

    def next_citation_index
      @citations.length + 1
    end
  end
end
