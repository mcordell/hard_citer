#require 'library'
require 'stringio'
require 'bibtex'
require '/Users/michael/Dropbox/Ruby/hard_citer/lib/cite_match'
require '/Users/michael/Dropbox/Ruby/hard_citer/lib/styler'
require 'citeproc'

class Citer
  attr_accessor :library, :styler

  def cite_text(in_text)
    @bibliography={}
    bib_location=nil
    out_array=[]
    if in_text.is_a?(Array)
      in_text=in_text.join("\n")
    end
    if in_text.is_a?(String)
      in_text=StringIO.open(in_text)
    end
    text_line_count=0


    in_text.each() do |line|
      regex_matches= self.parse_line(line)
      bib_line_match=self.check_for_bib_key(line)
      if bib_line_match
        bib_location=[text_line_count,bib_line_match]
      end
      cite_matches=regex_matches.map { |match| add_match_to_bib(match,@bibliography) }
      if cite_matches.length >  1
        cite_matches=self.group_matches(cite_matches,line)
      elif cite_matches.empty?
        new_line=line
      else
        new_line=styler.style_line(line,cite_matches)
      end
      out_array.push(new_line)
      text_line_count+=1
    end

    if bib_location
       bib_arr=styler.get_bibliography_lines(@bibliography,@csl)
       integrate(bib_arr,out_array,)
    else
      warn("No bib key found. Bibliography not added to cited text. In text-citation took place")
    end
    out_array
  end

  def add_match_to_bib(match,bibliography)
    match_key,match_pos=match
    if bibliography.has_key?(match_key)
      cite_match=bibliography[match_key]
    else
      cite_match=CiteMatch.new(match_key)
      cite_match.bib_number=bibliography.length+1
      cite_match.citation=get_citation_from_library(match_key)
      bibliography[match_key]=cite_match
    end
    out_match=[cite_match,match_pos]
  end

  def check_for_bib_key(line)
    line =~ @bib_key
  end

  def get_citation_from_library(match)
    citation=@library[convert_match_to_cite_key(match)]
  end

  def convert_match_to_cite_key(match)
    key=match.gsub(/\{|\}/,"")
  end

  def group_matches(matches,line)
    out_array=[]
    match_index=0
    while match_index < matches.length
      next_index=match_index+1
      if next_index < matches.length
        is_paired=test_for_paired_matches(matches[match_index],matches[next_index],line)
        if is_paired
          paired_array=[matches[match_index],matches[next_index]]
          match_index+=1
          next_index+=1
          while is_paired and next_index < matches.length
            is_paired=test_for_paired_matches(matches[match_index],matches[next_index],line)
            if is_paired
              paired_array.push(matches[next_index])
              match_index+=1
              next_index+=1
            end
          end
          out_array.push(paired_array)
        else
          out_array.push(matches[match_index])
        end
      else
        out_array.push(matches[match_index])
      end
      match_index+=1
    end
    return out_array
  end

  def test_for_paired_matches(match_first,match_second,line)
    match_text,match_pos=match_first
    next_match_text,next_match_pos=match_second
    end_of_match=match_pos+match_text.key.length
    white_space_re=/\s/
    while end_of_match < next_match_pos
      if line[end_of_match] == "s"
        end_of_match+=1
      else
        return false
      end
    end
    return true
  end
  

  def parse_line(line)
    regexp=/\{(\w*:\w*)\}/
    line.enum_for(:scan, regexp).map do
      match=Regexp.last_match
      pos=match.begin(0)
      [match.to_s,pos]
    end
  end
  

  def initialize( path=nil )
    #Create Citer object
    if path
      @library=Library.new(path)
    end
    @bib_key=/\{papers2_bibliography\}/
    @csl=CSL::Style.new("../examples/plos.csl")
  end

  def attach_bibtex_library(library_path)
    @library=BibTeX.open(library_path)
  end


end
if __FILE__ == $0
  post=<<-HTML
---
layout: TYPE
title: "TITLE"
date: DATE
---

  HTML
  title="x"
  post.gsub!('TITLE', title).gsub!('DATE', Time.new.to_s)
  x = Citer.new
  x.attach_bibtex_library("../examples/example_bib.bib")
  file_obj=open("../examples/example_input.html","r")
  x.styler=Styler.new
  pushed_text=x.cite_text(file_obj)


  matches=x.parse_line(sent)
  grouped_array=x.group_matches(matches,sent)
  puts grouped_array
end
