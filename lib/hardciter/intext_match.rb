# encoding: utf-8
module HardCiter
  BIBLIOGRAPHY_OUT_MATCH = 2
  INTEXT_CITATION_MATCH = 1 
  class IntextMatch
    attr_accessor :position, :type, :regex_match, :citation, :next_in_group

    def initialize(position=nil, regex_match=nil, type=nil)
      @position = position
      @regex_match = regex_match
      @type = type
    end

    def cite_key
      match_data = HardCiter.configuration.cite_key_pattern.match(@regex_match)
      match_data[0] if match_data.is_a? MatchData
    end
  end
end