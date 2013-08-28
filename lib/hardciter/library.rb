# encoding: utf-8
require 'bibtex'
module HardCiter
  class BibTexLibrary
    attr_accessor :bibtex

    def initialize(path=nil)
      load_from_file(path) if path
    end

    def load_from_file(path)
      @bibtex = BibTeX.open(path)
    end

    def get_citation(key)
      @bibtex[key]
    end

    def method_missing(method, *args, &block)
      @bibtex.send method, *args, &block
    end
  end
end
