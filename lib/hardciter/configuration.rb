module HardCiter
  class Configuration
    attr_accessor :csl 

    CSL = File.expand_path("../../../examples/plos.csl", __FILE__)

    def initialize
      self.reset
    end

    def reset
      @csl = CSL
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