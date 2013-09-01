module HardCiter
  class Configuration
    attr_accessor :csl, :bibliography_key, :citation_key, :bibtex_library_regex

    CSL = File.expand_path("../../../examples/plos.csl", __FILE__)
      
    BIBLIOGRAPHY_KEY = /\{papers2_bibliography\}/

    CITATION_KEY = /\{(\w*:\w*)\}/ 
    BIBTEX_LIBRARY_REGEX = /\.bib$/

    def initialize
      self.reset
    end

    def reset
      @csl = CSL
      @bibliography_key = BIBLIOGRAPHY_KEY
      @citation_key = CITATION_KEY 
      @bibtex_library_regex = BIBTEX_LIBRARY_REGEX
    end
  end

  class << self
    attr_accessor :configuration

    def configuration
      @configuration ||= Configuration.new
    end
  end

  def self.configure
    yield configuration if block_given? 
  end
end