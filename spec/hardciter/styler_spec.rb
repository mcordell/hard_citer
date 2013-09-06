# encoding: utf-8
require 'spec_helper'

module HardCiter
  describe HtmlOutput do
    let(:output) { HtmlOutput.new() }

    describe '#strip_extra_brackets' do
      it 'should return the line without brackets' do
        line = '{text}'
        output.strip_extra_brackets(line).should eq 'text'
      end
    end
  end
end