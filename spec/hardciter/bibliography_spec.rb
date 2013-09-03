# encoding: utf-8
module HardCiter
  describe Bibliography do

    let(:bibliography) { Bibliography.new }

    subject { :bibliography }
    describe "#add_intext_match" do
      let(:line_num) { 3 }
      context "when the line number is 3" do
        context "when intext_match is of the type BIBLIOGRAPHY_OUT_MATCH" do
          before do 
            @intext_match = IntextMatch.new
            @intext_match.type = HardCiter::BIBLIOGRAPHY_OUT_MATCH
            @result = bibliography.add_intext_match(@intext_match,line_num)
          end
          it "should set its bib_out_line to the line number 3" do
            bibliography.bib_out_line.should == line_num
          end

          it "should set its bib_out_citation to the IntextMatch" do
            bibliography.bib_out_match.should be @intext_match
          end

          it "should return nil" do
            @result.should be_nil
          end
        end

        context "when intext_match is of the type INTEXT_CITATION_MATCH \
                 with a cite_key that exists in its citations " do
          let(:cite_key) { "xyz:123" }
          before do 
            @cite_match = CiteMatch.new(cite_key)
            bibliography.citations[cite_key] = @cite_match
            @intext_match = IntextMatch.new
            @intext_match.type = INTEXT_CITATION_MATCH
            @intext_match.regex_match = cite_key
          end

          it "should return the CiteMatch from citations" do
            bibliography.add_intext_match(@intext_match,line_num).should be @cite_match
          end
        end
      end
    end
      
    

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