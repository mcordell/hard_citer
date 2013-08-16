# encoding: utf-8
require 'bibtex'
module HardCiter
  class Library < Hash

    def initialize(path = nil)
      load_lib(path) if path
    end

    def load_lib(path)
      File.open(path, 'r')
    end

    def get_citation()
    end
  end


  class BibtexLibrary < Library
    attr_accessor :bibtex

    def load_from_file(path)
      @bibtex = BibTeX.open(path)
    end

    def method_missing(method, *args, &block)
      @bibtex.send method, *args, &block
    end
  end
end
