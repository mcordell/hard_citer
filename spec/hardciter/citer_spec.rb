require File.expand_path("../../spec_helper", __FILE__)
require 'lib/hard_citer'


describe HardCiter::Citer do
  let(:citer) { HardCiter::Citer.new }

  subject { citer }

  it { should respond_to :library }
  it { should respond_to :bibliography }
  it { should respond_to :styler }


  describe "#initialize_library_by_path" do

    describe "path is a valid file ending in Bibtex's .bib extension" do
      let(:valid_path) { File.expand_path("../../../ex1amples/example_bib.bib", __FILE__)}
      it "should set its bibliography to a BibtexLibrary" do
        citer.initialize_library_by_path(valid_path) 
        citer.library.should be_kind_of(HardCiter::BibtexLibrary)
      end
    end

  end

end