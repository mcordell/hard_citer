require "spec_helper"
require "lib/cite_match"

describe "Cite Match" do

  describe "minimum of a key to make citation" do
      it "should create a Cite Match object with accessible key" do
        cite_match=CiteMatch.new("{LibraryWebsite:tt}")
        cite_match.key.should == "{LibraryWebsite:tt}"
      end
  end
end