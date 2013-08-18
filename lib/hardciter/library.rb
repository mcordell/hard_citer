# encoding: utf-8
require 'bibtex'
module HardCiter
  class Library < Hash

    def initialize(path = nil)
      load_lib(path)     
    end


    def load_lib(path = nil)
      if File.exists? path
        load_from_file(path)     
      end
    end

    def get_citation()
    end
  end


  class BibTexLibrary
    attr_accessor :bibtex

    def initialize(path)
      load_from_file(path)
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
