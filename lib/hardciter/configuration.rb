module HardCiter
  class Configuration
    attr_accessor :csl, :bibliography_pattern, :intext_pattern, 
                  :bibtex_library_regex, :cite_key_pattern

    CSL = File.expand_path("../../../examples/plos.csl", __FILE__)
      
    BIBLIOGRAPHY_PATTERN = /\{papers2_bibliography\}/

    INTEXT_PATTERN = /\{(\w*:\w*)\}/ 

    CITE_KEY_PATTERN = /\w*:\w*/

    BIBTEX_LIBRARY_REGEX = /\.bib$/


    def initialize
      self.reset
    end

    def reset
      @csl = CSL
      @bibliography_pattern = BIBLIOGRAPHY_PATTERN
      @intext_pattern = INTEXT_PATTERN
      @cite_key_pattern = CITE_KEY_PATTERN
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