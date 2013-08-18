require 'spec_helper'
require 'bibtex'
require 'lib/hardciter/library'

describe HardCiter::BibTexLibrary do

  let(:valid_bibtex_path) { File.expand_path("../../../examples/example_bib.bib", __FILE__) }

  let(:bibtex_library) { HardCiter::BibTexLibrary.new(valid_bibtex_path) }

  subject { bibtex }

  describe "initialization" do
    describe "with a valid path to a bib file" do
      it "should initalize its bibtex to a BibTeX::Bibliography object" do
        library = HardCiter::BibTexLibrary.new(valid_bibtex_path)
        library.bibtex.should be_kind_of(BibTeX::Bibliography)
      end
    end
  end

  describe "getting a citation that exists in the bibtex library" do
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

    describe "using the hash brackets" do
      it "should return a BibTex::Entry" do
        bibtex_library["pickaxe"].should be_kind_of(BibTeX::Entry)
      end
    end
  end

  describe "trying to get a citation that doesn't exist in the BibTex library" do

    describe "using the hash brackets" do
      it { bibtex_library["not-valid"].should be_nil }
    end
    
  end
end
