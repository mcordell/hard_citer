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

    describe '#output_line' do
      context "when there are no citations" do
        before do
         @line = "this line has no citations"
         @empty_citations = []
       end
        it "should return the same line" do
          output.output_line(@line,@empty_citations).should eq @line
        end
      end
    end
  end
end