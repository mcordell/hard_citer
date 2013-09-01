# encoding: utf-8
module HardCiter
  describe Bibliography do

    let(:bibliography) { Bibliography.new }

    subject { :bibliography }
    

    describe "#next_citation_index" do
      describe "should return the next available index in the citation list" do
        context "when the citation list is empty" do
          before { bibliography.citations = [] }
          it "should return 1" do
            bibliography.next_citation_index.should be 1
          end
        end
        context "when the citation list has 2 citations" do
          before { bibliography.citations = ["stub 1", "stub 2"] }
          it "should return 3" do
            bibliography.next_citation_index.should be 3
          end
        end
      end
    end
  end
end