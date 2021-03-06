# encoding: utf-8
require 'spec_helper'

module HardCiter
  describe Citer do
    let(:citer) { Citer.new }
    let(:valid_path) { File.expand_path('../../../examples/example_bib.bib', __FILE__) }

    subject { citer }

    it { should respond_to :library }
    it { should respond_to :bibliography }
    it { should respond_to :output }

    describe '#initialize_library_by_path' do
      context "path is a valid file ending in Bibtex's .bib extension" do
        it 'should set its bibliography to a BibtexLibrary' do
          citer.initialize_library_by_path(valid_path)
          citer.library.should be_kind_of(BibTexLibrary)
        end
      end
      context "when path is not a known format" do
        before { @invalid_path = 'xyz.avi' }
        it 'should raise an error' do
          expect { citer.initialize_library_by_path(@invalid_path) }.
          to raise_error(StandardError, 'Unknown library path type')
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

    describe "#parse_all_lines" do
      let(:document) { Document.new }
      context "when supplied a document with intext citations" do
        before do
          document.text_array = [ "This sentence has a citation{xyz:123}.",
            "This sentence does not.",
            "But this one has {x2:jk}, has one in the middle."]
        end
        it "should return a lines with IntextMatches on lines that have them" do
          result = citer.parse_all_lines(document)
          result[0][0].should be_kind_of(IntextMatch)
          result[1].should be_empty
          result[2][0].should be_kind_of(IntextMatch)
        end
      end
    end

    describe "#get_entries_from_library" do
      context "@library is nil" do
        before { citer.library = nil }
        it "should raise an exception" do
          expect { citer.get_entries_from_library }.to raise_error "Library is not set. Cannot get entries."
        end
      end
      context "@bibliography is nil" do
        before do
          citer.library = double("library")
          citer.bibliography = nil
        end
        it "should raise an exception" do
          expect { citer.get_entries_from_library }.to raise_error "Bibliography is not set. Cannot get entries."
        end
      end

      context "@bibliography is not nil but @bibliography.citations is nil" do
        before  do
          citer.library = double("library")
          bibliography = double("bilbiography")
          bibliography.stub(:citations) { nil }
          citer.bibliography = bibliography
        end

        it "should raise an exception" do
          expect { citer.get_entries_from_library }.to raise_error "Bibliography has no citations"
        end
      end

      context "@bibliography is not nil but @bibliography.citations is empty" do
        before  do
          citer.library = double("library")
          bibliography = double("bilbiography")
          bibliography.stub(:citations) { [] }
          citer.bibliography = bibliography
        end

        it "should raise an exception" do
          expect { citer.get_entries_from_library }.to raise_error "Bibliography has no citations"
        end
      end
    end

    describe "#group_matches!" do
      context "with a line has one match that follows another" do
        before do
          @line = "{match:one}{match:two}"
          @matches = Parser.new.parse_line(@line)
          @first_match = @matches[0]
          @second_match = @matches[1]
          citer.group_matches!(@matches, @line)
        end

        describe "moves the trailing match to the leading match's next_in_group" do
          it "should add the trailing match to leading match's next_in_group" do
            @first_match.next_in_group.should be @second_match
          end
          it "should delete the second match from the matches" do
            @matches.should_not include(@second_match)
          end
        end
      end

      context "with a line that has one match that follows another with white space" do
        before do
          @line = "{match:one} {match:two}"
          @matches = Parser.new.parse_line(@line)
          @first_match = @matches[0]
          @second_match = @matches[1]
          citer.group_matches!(@matches, @line)
        end
        describe "moves the trailing match to the leading match's next_in_group" do
          it "should add the trailing match to leading match's next_in_group" do
            @first_match.next_in_group.should be @second_match
          end
          it "should delete the second match from the matches" do
            @matches.should_not include(@second_match)
          end
        end
      end

      context "with a line that has three matches in a row" do
        before do
          @line = "{match:one}{match:two}{match:three}"
          @matches = Parser.new.parse_line(@line)
          @first_match = @matches[0]
          @second_match = @matches[1]
          @third_match = @matches[2]
          citer.group_matches!(@matches, @line)
        end
        describe "moves the trailing match to the leading match's next_in_group" do
          it "should add the second match to leading match's next_in_group" do
            @first_match.next_in_group.should be @second_match
          end
          it "should add the third match to second match's next_in_group" do
            @second_match.next_in_group.should be @third_match
          end
          it "should leave the first_match in the matches array" do
            @matches.should include(@first_match)
          end
          it "should delete the second and third match from the matches" do
            @matches.should_not include(@second_match)
            @matches.should_not include(@third_match)
          end
        end
      end

      context "with a line that has three matches, with two in a row" do
        before do
          @line = "This sentence has two paired citations{Davis:2003wp}{Biswal:2010fj} and
                  a lone citation{Jones:1999qs}."
          @matches = Parser.new.parse_line(@line)
          @first_match = @matches[0]
          @second_match = @matches[1]
          @third_match = @matches[2]
          citer.group_matches!(@matches, @line)
        end
        describe "moves the trailing match to the leading match's next_in_group" do
          it "should add the second match to leading match's next_in_group" do
            @first_match.next_in_group.should be @second_match
          end
          it "should delete the second match from the matches" do
            @matches.should_not include(@second_match)
          end
          it "should not delete the third match from matches" do
            @matches.should include(@third_match)
          end
        end
      end
    end
  end
end
