# encoding: utf-8
module HardCiter
  BIBLIOGRAPHY_OUT_MATCH = 2
  INTEXT_CITATION_MATCH = 1 
  class IntextMatch
    attr_accessor :position, :type, :regex_match
  end
end