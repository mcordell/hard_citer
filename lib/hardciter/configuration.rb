module HardCiter
  class Configuration
    attr_accessor :csl, :bibliography_key, :citation_key

    CSL = File.expand_path("../../../examples/plos.csl", __FILE__)
      
    BIBLIOGRAPHY_KEY = /\{papers2_bibliography\}/

    CITATION_KEY = /\{(\w*:\w*)\}/ 

    def initialize
      self.reset
    end

    def reset
      @csl = CSL
      @bibliography_key = BIBLIOGRAPHY_KEY
      @citation_key = CITATION_KEY 
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