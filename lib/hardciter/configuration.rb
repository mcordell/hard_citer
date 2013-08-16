module HardCiter
  class Configuration
    attr_accessor :csl 

    CSL = File.expand_path("../../../examples/plos.csl", __FILE__)
      
    BIBLIOGRAPHY_INTEXT_KEY = /\{papers2_bibliography\}/

    def initialize
      self.reset
    end

    def reset
      @csl = CSL
      @bibliography_intext_key = BIBLIOGRAPHY_INTEXT_KEY
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