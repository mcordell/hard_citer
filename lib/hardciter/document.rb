# encoding: utf-8
require 'stringio'
require File.expand_path('../exceptions', __FILE__)

module HardCiter
  class Document
    attr_reader :text_array

    def initialize(text = nil)
      self.text_array = text
    end

    def text_array=(text)
      if text.is_a? File
        @text_array = text.readlines()
      elsif text.is_a? String
        @text_array = StringIO.open(text).readlines()
      elsif text.is_a? Array
        @text_array = text
      elsif text.nil?
        @text_array = nil
      else
        raise HardCiter::InvalidTextFormat
      end
    end

  end
end



