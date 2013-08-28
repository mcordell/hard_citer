# encoding: utf-8
require 'spec_helper'

module  HardCiter
  describe BibTexLibrary do
    let(:valid_bibtex_path) { File.expand_path('../../../examples/example_bib.bib', __FILE__) }
    let(:bibtex_library) { BibTexLibrary.new(valid_bibtex_path) }

    subject { bibtex }

    describe 'initialization' do
      describe 'with a valid path to a bib file' do
        it 'should initalize its bibtex to a BibTeX::Bibliography object' do
          library = BibTexLibrary.new(valid_bibtex_path)
          library.bibtex.should be_kind_of(BibTeX::Bibliography)
        end
      end
    end


    describe 'getting a citation'  do
      before do
        bibtex_library.bibtex = BibTeX.parse <<-END
        @book{pickaxe,
          address = {Raleigh, North Carolina},
          author = {Thomas, Dave and Fowler, Chad and Hunt, Andy},
          publisher = {The Pragmatic Bookshelf},
          series = {The Facets of Ruby},
          title = {Programming Ruby 1.9: The Pragmatic Programmer's Guide},
          year = {2009}
        }
        END
      end

      context 'citation exists in BibTexLibrary' do 
        describe 'using the hash brackets' do
          it 'should return a BibTex::Entry' do
            bibtex_library['pickaxe'].should be_kind_of(BibTeX::Entry)
          end
        end

        describe "using the get_citation method" do
          it 'should return a BibTex::Entry' do
            bibtex_library['pickaxe'].should be_kind_of(BibTeX::Entry)
          end
        end
      end

      context 'citation does not exist in the BibTex library' do
        describe 'using the hash brackets' do
          it { bibtex_library.get_citation('not-valid').should be_nil }
        end
      end
    end


    describe '#load_from_file' do
      context 'with a blank library and a valid path' do
        before { @blank_library = BibTexLibrary.new() } 
        it 'should load a valid Bibtex::Bibliography into its bibtex' do
          @blank_library.load_from_file(valid_bibtex_path)
          @blank_library.bibtex.should be_kind_of(BibTeX::Bibliography)
        end
      end
    end
  end
end