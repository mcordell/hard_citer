# encoding: utf-8
require 'spec_helper'
module HardCiter
  describe IntextMatch do
    let(:intext_match) { IntextMatch.new }
    subject { intext_match }

    it { should respond_to :position }
    it { should respond_to :regex_match }
    it { should respond_to :type }

    describe "#cite_key" do
      context "using the configured cite_key pattern with a valid match in regex_match" do
        before do            
          HardCiter.configure do |config|
            config.cite_key_pattern = /\w*:\w*/
            intext_match.regex_match = "{ johnson:1234 }"
          end
        end
        it "should return the city key" do
          intext_match.cite_key.should == "johnson:1234"
        end
      end

      context "when the regex_match is nil" do
        it { intext_match.cite_key.should be_nil }
      end

      context "when the regex_match does not match the cite_key pattern" do
        before { intext_match.regex_match = "notamatch" }
        it { intext_match.cite_key.should be_nil }
      end
    end
  end
end