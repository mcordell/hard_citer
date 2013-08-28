# encoding: utf-8
require 'spec_helper'

module HardCiter

  describe Document do
    let(:doc) { Document.new }

    subject { doc }

    it { should respond_to :text_array }

    describe 'initialization' do
      it 'takes input and converts sets text_array with it' do
        document = Document.new('Strings')
        document.text_array.should eq ['Strings']
      end
    end

    describe '#text_array=(text)' do
      context 'text is a string' do
        it 'should set @text_array to an array with a string for each line' do
          doc.text_array = "String\nString2"
          doc.text_array.should eq ["String\n", 'String2']
        end
      end

      context 'text is an array of strings' do
        let(:array_of_strings) { %w('String1', 'String2') }
        before do
          doc.text_array = array_of_strings
        end
        it { doc.text_array.should be array_of_strings  }
      end

      context 'text is a file object' do
        let(:filename) { 'filename' }
        let(:lines_array) { %w("String1","String2") }

        before do 
          File.open filename, 'w' do |file|
            lines_array.each do |line|
              file.write(line)
            end
          end
        end

        after do
          File.delete(filename)
        end

        it "should have a matching string array to file contents" do
          file_object = File.open(filename, 'r')
          doc.text_array = file_object
          doc.text_array.should eq lines_array
        end
      end

      context 'text is an unknown formats' do
        it 'raises an InvalidTextFormat error'  do
          expect { Document.new(3) }.to raise_error(InvalidTextFormat)
        end
      end

      context 'text is nil' do
        before { doc.text_array = nil }
        it { doc.text_array.should be nil }
      end
    end
  end
end