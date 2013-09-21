# encoding: utf-8
module HardCiter  
  class Citation
    attr_accessor :bib_number, :entry, :in_cite_text, :key

    def initialize(key, entry = nil, in_cite_text = nil)
      @key = key
      @entry = entry
      @in_cite_text = in_cite_text
    end
  end
end

