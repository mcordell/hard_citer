# encoding: utf-8
module HardCiter
  BIBLIOGRAPHY_OUT_MATCH = 2
  INTEXT_CITATION_MATCH = 1 
  class IntextMatch
    attr_accessor :position, :type, :regex_match

    def initialize(position=nil, regex_match=nil, type=nil)
      @position = position
      @regex_match = regex_match
      @type = type
    end
  end
end