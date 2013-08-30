# encoding: utf-8
module HardCiter
  class Parser
    attr_accessor :bib_key, :citation_key

    def initialize(bib_key=nil,citation_key=nil)
      @bib_key = bib_key ? bib_key : HardCiter.configuration.bibliography_key
      @citation_key = citation_key ? citation_key : HardCiter.configuration.citation_key
    end

    def parse_line(line)
      return []
    end
  end
end