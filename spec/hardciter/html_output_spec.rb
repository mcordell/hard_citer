# encoding: utf-8
require 'spec_helper'

module HardCiter
  describe HtmlOutput do
    let(:output) { HtmlOutput.new() }
    let(:intext_pattern) { /\{(\w*:\w*)\}/ }
    let(:intext_out_open) { "<sup>" }
    let(:intext_out_close) { "</sup>" }

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

      context "when there is a single citation" do
        before do 
          @line = "a line with a{citation:xyz} in it"
          citation = double("Citation")
          @intext_match = double("In Text Match")
          @intext_match.stub(:citation){ citation }
          @intext_match.stub(:position){ intext_pattern.match(@line).begin(0) }
          @intext_match.stub(:regex_match){ intext_pattern.match(@line).to_s }
          citation.stub(:intext_output){ "3" }
          combined_output = intext_out_open+citation.intext_output+intext_out_close
          @output_line = @line.gsub(intext_pattern,combined_output) 
        end

        it "should return the line with the citation replaced by the proper marker" do
          output.output_line(@line,[@intext_match]).should eq @output_line
        end
      end
    end
  end
end