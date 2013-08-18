module HardCiter
  class Configuration
    attr_accessor :csl, :bibliography_intext, :intext_regex

    CSL = File.expand_path("../../../examples/plos.csl", __FILE__)
      
    BIBLIOGRAPHY_INTEXT_KEY = /\{papers2_bibliography\}/

    INTEXT_REGEX = /\{(\w*:\w*)\}/

    def initialize
      self.reset
    end

    def reset
      @csl = CSL
      @bibliography_intext = BIBLIOGRAPHY_INTEXT_KEY
      @intext_regex = INTEXT_REGEX
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