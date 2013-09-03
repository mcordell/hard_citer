# encoding: utf-8
module HardCiter  
  class Citation
    attr_accessor :bib_number, :citation, :in_cite_text, :key

    def initialize(key, citation = nil, in_cite_text = nil)
      @key = key
      @citation = citation
      @in_cite_text = in_cite_text
    end

  end
end

