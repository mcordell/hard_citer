require File.expand_path("../../spec_helper", __FILE__)
require 'lib/hardciter/document'


describe HardCiter::Document do
  let(:doc) { HardCiter::Document.new }

  subject { doc }

  it { should respond_to :text_array }

  describe "initialization" do
    it "takes input and converts sets text_array with it" do
      document = HardCiter::Document.new("Strings")
      document.text_array.should eq ["Strings"]
    end
  end

  describe "#text_array=(text)" do

    context "text is a string" do
      it "should set @text_array to an array with a string for each line" do
        doc.text_array = "String\nString2"
        doc.text_array.should eq ["String\n","String2"]
      end
    end

    context "text is an array of strings" do
      let(:array_of_strings) { ["String1", "String2"] }
      before do
        doc.text_array = array_of_strings
      end
      it { doc.text_array.should be array_of_strings  }
    end

    context "text is a file object" do
      let(:lines_array) { ["String1", "String2"] }
      let(:file_object) do
        File.open "filename", "w" do |file|
          lines_array.each do |line|
            file.write(line)
          end
        end
      end

      before { doc.text_array = file_object }

      it { doc.text_array.should be lines_array  }
    end

    context "text is an unknown formats" do
      it "raises an InvalidTextFormat error"  do
        expect { HardCiter::Document.new(3) }.to raise_error(HardCiter::InvalidTextFormat)
      end
    end

    context "text is nil" do
      before { doc.text_array = nil }
      it { doc.text_array.should be nil }
    end

  end

end