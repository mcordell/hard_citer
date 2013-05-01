require 'spec_helper'
require './lib/hard_citer'

describe Citer do
  let(:hard_citer){ Citer.new }

  describe "parse sentence function" do 

    describe "parsing a sentence with a reference" do
      it "should return the location pair" do
        parse_result=hard_citer.parse_sentence "Hey man this is a sentence with a citation at the end {Wasmuth:2000vy}."
        parse_result.should == [['{Wasmuth:2000vy}',54]]
      end
    end

    describe "parsing a sentence without a refrence" do
      it "should return nil" do
        parse_result=hard_citer.parse_sentence "Hey man this is a sentence without a citation at the end." 
        parse_result.should be_empty
      end
    end

    describe "parsing a sentence with multiple refrences next to each other" do
      it "should return the location pair" do
        parse_result=hard_citer.parse_sentence "This sentence has two citations at the end{Biswal:2010fj}{Davis:2003wp}." 
        parse_result.should == [["{Biswal:2010fj}", 42], ["{Davis:2003wp}", 57]]
      end
    end
    
  end


end
