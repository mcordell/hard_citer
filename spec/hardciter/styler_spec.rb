# encoding: utf-8
require 'spec_helper'

module HardCiter
  describe Styler do
    let(:styler) { Styler.new() }

    describe '#strip_extra_brackets' do
      it 'should return the line without brackets' do
        line = '{text}'
        styler.strip_extra_brackets(line).should eq 'text'
      end
    end
  end
end