# encoding: utf-8
require 'spec_helper'

module HardCiter
  describe Citation do
    describe 'initialization' do
      context 'when a key is provide' do
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