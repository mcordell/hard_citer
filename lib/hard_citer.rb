# encoding: utf-8
require 'stringio'
require 'bibtex'
require_relative 'cite_match'
require_relative 'styler'
require 'citeproc'

class Citer
  attr_accessor :library, :styler

  def cite_text(in_text)
    @bibliography = {}
    bib_location = nil
    out_array = []
    in_text = in_text.join("\n") if in_text.is_a?(Array)
    in_text = StringIO.open(in_text) if in_text.is_a?(String)
    text_line_count = 0

    in_text.each_with_index() do |line, index|
      regex_matches = self.parse_line(line)
      bib_line_match = self.check_for_bib_key(line)
      bib_location = [text_line_count, bib_line_match] if bib_line_match
      cite_matches = regex_matches.each do |match|
        add_match_to_bib(match, @bibliography)
      end

      if cite_matches.length >  1
        cite_matches = self.group_matches(cite_matches, line)
        new_line = styler.style_line(line, cite_matches)
      elsif cite_matches.empty?
        new_line = line
      else
        new_line = styler.style_line(line, cite_matches)
      end
      out_array.push(new_line)
      text_line_count += 1
    end

    if bib_location
       bib_arr = styler.get_bibliography_lines(@bibliography, @csl)
       out_array = integrate(bib_arr, out_array, bib_location)
    else
      warn('No bib key found. \
           Bibliography not added to cited text. \
           In text - citation took place')
    end
    out_array
  end

  def integrate(bib_array, in_array, bib_location)
     second_half = in_array[bib_location[0] + 1..in_array.size - 1]
     in_array[0..bib_location[0] - 1] + bib_array + second_half
  end

  def add_match_to_bib(match, bibliography)
    match_key, match_pos = match
    if bibliography.has_key?(match_key)
      cite_match = bibliography[match_key]
    else
      cite_match = CiteMatch.new(match_key)
      cite_match.bib_number = bibliography.length + 1
      cite_match.citation = get_citation_from_library(match_key)
      bibliography[match_key] = cite_match
    end
    [cite_match, match_pos]
  end

  def check_for_bib_key(line)
    line =~ @bib_key
  end

  def get_citation_from_library(match)
    @library[convert_match_to_cite_key(match)]
  end

  def convert_match_to_cite_key(match)
    match.gsub(/\{|\}/, '')
  end

  def group_matches(matches, line)
    out_array = []
    match_index = 0
    while match_index < matches.length
      next_index = match_index + 1
      if next_index < matches.length
        is_paired = test_for_paired_matches(matches[match_index],
                                            matches[next_index], line)
        if is_paired
          paired_array = [matches[match_index], matches[next_index]]
          match_index += 1
          next_index += 1
          while is_paired && next_index < matches.length
            is_paired = test_for_paired_matches(matches[match_index],
                                                matches[next_index], line)
            if is_paired
              paired_array.push(matches[next_index])
              match_index += 1
              next_index += 1
            end
          end
          out_array.push(paired_array)
        else
          out_array.push(matches[match_index])
        end
      else
        out_array.push(matches[match_index])
      end
      match_index += 1
    end
    return out_array
  end

  def test_for_paired_matches(match_first, match_second, line)
    match_text, match_pos = match_first
    next_match_pos = match_second[1]
    end_of_match = match_pos + match_text.key.length
    while end_of_match < next_match_pos
      if line[end_of_match] == 's'
        end_of_match += 1
      else
        return false
      end
    end
    return true
  end

  def parse_line(line)
    regexp = /\{(\w*:\w*)\}/
    line.enum_for(:scan, regexp).map do
      match = Regexp.last_match
      pos = match.begin(0)
      [match.to_s, pos]
    end
  end

  def initialize(path = nil)
    @library = Library.new(path) if path
    @bib_key = /\{papers2_bibliography\}/
    @csl = CSL::Style.new('../examples/plos.csl')
  end

  def attach_bibtex_library(library_path)
    @library = BibTeX.open(library_path)
  end

end
