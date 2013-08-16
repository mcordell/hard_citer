require "spec_helper"
require 'lib/hard_citer'

describe HardCiter::CiteMatch do
  describe "initialization" do
    describe "when a key is provide" do
        it "should create a Cite Match object with accessible key" do
          cite_match=HardCiter::CiteMatch.new("{LibraryWebsite:tt}")
          cite_match.key.should == "{LibraryWebsite:tt}"
        end
    end
    describe "when a key is not provided" do
      it "should raise a error" do
        expect{ HardCiter::CiteMatch.new() }.to raise_error
      end
    end
  end
end