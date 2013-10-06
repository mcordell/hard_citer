# encoding: utf-8
require 'citeproc'
module HardCiter
  class HtmlOutput
    attr_accessor :csl, :bibliography

    def initialize(csl=nil)
      @csl = csl if csl
      @open_tag = '<sup>['
      @close_tag = ']</sup>'
      @multi_separator = ','
      @separator_after_last = false
    end

    def output_line(line,intext_matches)
      intext_matches.each do |match|
        line_front = line[0..match.position-1]
        line_end = line[match.position+match.regex_match.length..-1]
        intext_out = @open_tag + match.citation.intext_output + @close_tag
        line = line_front + intext_out + line_end
      end
      line
    end

    def process_and_output_text(text,intext_matches)
      text = text.text_array
      raise "prepare_bibliography has not been run, cannot process text" if @bibliography.nil?
      check_text_and_matches_length(text,intext_matches)
      output = []
      text.each_with_index do |line,index|
        output+=style_line(line,intext_matches[index])
      end
      output
    end

    def check_text_and_matches_length(text,intext_matches)
      if text.length != intext_matches.length
        raise "Document length and intext_matches length are different, aborting."
      end
    end

    def prepare_bibliography(bibliography)
      @bibliography = ['<ol class="bibliography">']
      bibliography.citations.each do |citation_key,citation|
        entry = citation.entry
        if entry.nil?
          cite_text = citation_key
        else
          cite_text = CiteProc.process(entry.to_citeproc, style: @csl, format: :html)
          strip_extra_brackets(cite_text)
          @bibliography.push '<li><a name = "' +
                         "bibliography_#{citation.bib_number}\">" +
                         cite_text + '</a></li>'
        end
      end
      @bibliography.push('</ol>')
    end

    def strip_extra_brackets(line)
        line.gsub!(/\{|\}/, '')
    end

    def style_line(line, line_matches)
      pos_offset = 0
      line_matches.each do |match|
        if match
          if match.type == BIBLIOGRAPHY_OUT_MATCH
           return @bibliography
          elsif match.next_in_group.nil?
            line,pos_offset = single_cite(match,line,pos_offset)
          else
            line,pos_offset = multi_cite(match, line, pos_offset)
          end
        end
      end
      return [line]
    end

    def multi_cite(match, line, pos_offset)
      original_line_length = line.length
      pos = match.position + pos_offset
      before,after = split_at_match(pos,match.regex_match.length,line)
      after = split_group_matches(match.next_in_group,after)
      intexts = []
      while match do
        intexts.push(get_intext(match.citation))
        match = match.next_in_group
      end
      output_line = before + wrap_intext(intexts) + after
      pos_offset += (output_line.length - original_line_length)
      return output_line, pos_offset
    end

    def split_group_matches(match,line)
      while match do
        match_pos = Regexp.new(match.regex_match).match(line)
        if match_pos.nil?
          raise "match missing?"
        else
          line.slice!(match_pos.begin(0)..match.regex_match.length)
        end
        match = match.next_in_group
      end
      line
    end

    def split_at_match(pos,match_length,line)
      pos == 0 ? before = '' : before = line.slice!(0..pos - 1)
      after = line.slice(match_length,line.length)
      return before,after
    end

    def single_cite(match, line, pos_offset)
      original_line_length = line.length
      pos = match.position += pos_offset
      before,after = split_at_match(pos,match.regex_match.length, line)
      in_text_citation = wrap_intext([get_intext(match.citation)])
      output_line = before + in_text_citation + after
      pos_offset += (output_line.length - original_line_length)
      return output_line, pos_offset
    end

    def get_intext(citation)
      number = citation.bib_number
      "<a href = \"#bibliography_#{number}\">#{number}</a>"
    end

    def wrap_intext(intext_citations)
      output = @open_tag
      intext_citations.each_with_index do |intext, index|
        output += intext
        output += @multi_separator unless index == intext_citations.length-1
      end
      output += @close_tag
    end
  end
end
