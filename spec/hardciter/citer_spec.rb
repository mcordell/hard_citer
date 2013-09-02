# encoding: utf-8
require 'spec_helper'

module HardCiter
  describe Citer do
    let(:citer) { Citer.new }
    let(:valid_path) { File.expand_path('../../../examples/example_bib.bib', __FILE__) }

    subject { citer }

    it { should respond_to :library }
    it { should respond_to :bibliography }
    it { should respond_to :styler }

    describe '#initialize_library_by_path' do
      context "path is a valid file ending in Bibtex's .bib extension" do
        it 'should set its bibliography to a BibtexLibrary' do
          citer.initialize_library_by_path(valid_path)
          citer.library.should be_kind_of(BibTexLibrary)
        end
      end
    end

    describe "#validate_prerequisites" do
      context "when library is nil" do
        before { citer.library = nil }
        it "should raise an error" do
          expect { citer.validate_prerequisites}.
          to raise_error(StandardError, 'Library missing cannot proceed with citation')
        end
      end
      context "when csl is nil" do
        before do 
          citer.initialize_library_by_path(valid_path)
          citer.csl = nil
        end
        it "should raise an error" do
          expect { citer.validate_prerequisites}.
          to raise_error(StandardError, 'No citation format found, cannot proceed with citation')
        end
      end
    end
  end
end