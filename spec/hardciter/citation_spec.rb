# encoding: utf-8
require 'spec_helper'

module HardCiter
  describe Citation do
    let(:key){ "{sample:key}" }
    let(:citation){ Citation.new(key) }

    subject { citation }

    it { should respond_to :bib_number } 
    it { should respond_to :entry }
    it { should respond_to :in_cite_text }
    it { should respond_to :key }
    
    describe 'initialization' do
      context 'when a key is provided' do
          it 'should create a Cite Match object with accessible key' do
            cite_match = Citation.new('{LibraryWebsite:tt}')
            cite_match.key.should == '{LibraryWebsite:tt}'
          end
      end
      context 'when a key is not provided' do
        it 'should raise a error' do
          expect { Citation.new() }.to raise_error
        end
      end
    end
  end
end