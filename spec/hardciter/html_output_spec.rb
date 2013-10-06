# encoding: utf-8
require 'spec_helper'
module HardCiter
  describe HtmlOutput do
    let(:output) { HtmlOutput.new }
    let(:intext_pattern) { /\{(\w*:\w*)\}/ }
    let(:intext_out_open) { "<sup>[" }
    let(:intext_out_close) { "]</sup>" }

    subject{ output }

    it { should respond_to :csl }

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

    describe "#prepare_bibliography" do
      context "when provided a bibliography object" do
        before do
         @bibliography = double("bibliography")
         @citation.stub(:entry){ nil }
         @bibliography.stub(:citations){ [] }
       end

        it "should store the output in its @bibliography variable" do
          expect do
            output.prepare_bibliography(@bibliography)

            end.
          to change{output.bibliography}.from(NilClass).to(Array)
        end
      end
    end

    describe "#procces_and_output_text" do
      context "when prepare_bibliography has not been run" do
        before do
          output.instance_eval do
            @bibliography = nil
          end
          @document.stub(:text_array){ [] }
        end
        it "should throw an error" do
          expect {
            output.process_and_output_text(@document,double("intext_matches"))
            }.to raise_error "prepare_bibliography has not been run, cannot process text"
        end
      end

      context "when intext_matches does not match document.text_array length" do
        before do
          output.bibliography = double("bib")
          @intext_matches = ["citation"]
          @document.stub(:text_array){ ["line1","line2"] }
        end

        it "should throw an error" do
          expect { output.process_and_output_text(@document,@intext_matches) }.
          to raise_error "Document length and intext_matches length are different, aborting."
        end
      end

      context 'when provided proper inputs' do
        before do
          @bib = mock(Bibliography)
          output.bibliography = double("bib")
          @intext_matches = [[double("intext_match")]]
          @document = mock Document
          @document.stub(:text_array){ ["line"] }
          output.stub(:style_line){ ["this would be a styled line"] }
        end
        it "should return an array of equal length to the input text" do
          @document.text_array.length.should == output.process_and_output_text(@document,@intext_matches).length
        end
      end


   end
  end
end
