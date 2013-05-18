# encoding: utf-8
require 'citeproc'
class Styler

  def get_bibliography_lines(bibliography_array, csl_style)
    out_lines = ['<ol>']
    bibliography_array.each do |cite_key, cite_match|
      entry = cite_match.citation
      if entry.nil?
        cite_text = cite_key
      else
        cite_text = CiteProc.process(cite_match.citation.to_citeproc,
                                     style: csl_style, format: :html)
        strip_extra_papers_brackets cite_text
      end

      out_lines.push '<li><a name = "' +
                     "bibliography_#{cite_match.bib_number}\">" +
                     cite_text + '</a></li>'
    end
    out_lines.push '</ol>'
  end

  def strip_extra_papers_brackets(line)
      line.gsub!(/\{|\}/, '')
  end

  def style_line(line, citations)
    processed_line = ''
    pos_off_set = 0
    citations.each do |cite_match|
      if cite_match[0].is_a?(CiteMatch)
        output, offset = single_cite(cite_match[0],
                                     cite_match[1] - pos_off_set, line)
        pos_off_set += offset

      elsif cite_match[0].is_a? Array
        output = multi_cite(cite_match, line, pos_off_set)
      end
      processed_line += output
    end
    processed_line += line
  end

  def multi_cite(cite_match_array, line, pos_offset)
    output_line = @open_tag
    cite_match_array.each_with_index do |cite_match, index|
      citation, pos = cite_match
      output, off_set = single_cite(citation, pos - pos_offset, line)
      output_line += output
      output_line += @multi_separator unless index == cite_match.size - 1
      pos_offset += off_set
    end
    output_line += @close_tag

  end

  def single_cite(citation, pos, line)
    key = citation.key
    pos == 0 ? before_cite = '' : before_cite = line.slice!(0..pos - 1)
    cite = line.slice!(0..key.length - 1)
    off_set = before_cite.length + cite.length
    in_text_citation = "<sup><a href = \"#bibliography_#{citation.bib_number}\
                        \">#{citation.bib_number}</a></sup>"
    output_line = before_cite + in_text_citation
    [output_line, off_set]
  end

  def initialize
    @open_tag = ''
    @close_tag = ''
    @multi_separator = '<sup>, </sup>'
    @separator_after_last = false
  end
end
