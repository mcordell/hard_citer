# encoding: utf-8
require 'spec_helper'

module HardCiter
  describe Citer do
    let(:citer) { Citer.new }

    subject { citer }

    it { should respond_to :library }
    it { should respond_to :bibliography }
    it { should respond_to :styler }

    describe '#initialize_library_by_path' do
      describe "path is a valid file ending in Bibtex's .bib extension" do
        let(:valid_path) { File.expand_path('../../../examples/example_bib.bib', __FILE__) }
        it 'should set its bibliography to a BibtexLibrary' do
          citer.initialize_library_by_path(valid_path)
          citer.library.should be_kind_of(BibTexLibrary)
        end
      end
    end
  end
end