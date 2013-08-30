# encoding: utf-8
require 'spec_helper'
module HardCiter
  describe IntextMatch do
    subject { IntextMatch.new }

    it { should respond_to :position }
    it { should respond_to :regex_match }
    it { should respond_to :type }
  end
end