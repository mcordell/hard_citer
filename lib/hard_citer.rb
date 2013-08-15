# encoding: utf-8
require 'stringio'
require 'bibtex'
require 'citeproc'
require_relative 'cite_match'
require_relative 'styler'

class HardCiter
  attr_accessor :library, :styler

  def clean_line_matches(citation_matches,line)
    if citation_matches.length >  1
      return group_matches(citation_matches, line)
    else
      return citation_matches
    end
  end

  def regex_matches_to_cite_matches(regex_matches)
    cite_matches = regex_matches.map { |m|
      add_match_to_bib(m,@bibliography)
    }
    return cite_matches
  end

  def find_all_citations(text)
    bib_location = nil
    all_citations = {}
    text.each_with_index() do |line, index|
      regex_matches = parse_line(line)
      bib_location = index if is_bib_key?(line)
      matches=regex_matches_to_cite_matches(regex_matches) unless regex_matches.empty?
      all_citations[index] = clean_line_matches(matches,line) unless matches.nil?
    end
    return bib_location,all_citations
  end

  def text_to_array(text)
    text = text.readlines() if text.is_a?(File)
    text = StringIO.open(text).readlines() if text.is_a?(String)
    return text
  end

  def integrate_citations_into_text!(text,all_citations)
    all_citations.each do |line_number,cite_matches|
      text_line = text[line_number]
      text[line_number] = @styler.style_line(text_line,cite_matches)
    end
  end

  def integrate_bibliography_into_text(text,bib_location)
    if bib_location
      bib_text = styler.get_bibliography_lines(@bibliography, @csl)
      after_bib_location = text[(bib_location + 1)..text.size - 1]
      return text[0..bib_location - 1] + bib_text + after_bib_location
    else
      warn('No bib key found. \
           Bibliography not added to cited text.')
      return text
    end
  end

  def cite_text(text)
    text = text_to_array(text)
    bib_location,all_citations= find_all_citations(text)
    integrate_citations_into_text!(text,all_citations)
    return integrate_bibliography_into_text(text,bib_location)
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

  def is_bib_key?(line)
    line =~ @bib_key
  end

  def get_citation_from_library(match)
    @library[convert_match_to_cite_key(match)]
  end

  def convert_match_to_cite_key(match)
    match.gsub(/\{|\}/, '')
  end

  def group_matches(matches,line)
    matches_grouped = []
    current_match = matches.shift
    until matches.empty?
      next_match = matches.shift
      if matches_are_paired?(current_match,next_match,line)
        current_match = pair_two_matches(current_match, next_match)
      else
        matches_grouped.push(current_match) if current_match
        current_match = next_match
      end
    end
    matches_grouped.push(current_match) unless current_match.empty?
    return matches_grouped
  end

  def pair_two_matches(current_match,next_match)
    if current_match[0].instance_of?(Array)
      paired_matches = current_match + next_match
    else
      paired_matches = [current_match,next_match]
    end
  end


  def get_match_text_and_pos(match_group)
    if match_group[0].instance_of?(Array)
      #match_group has sub arrays so it needs to be unpacked
      last_match = match_group[match_group.size-1]
    else
      last_match = match_group
    end
    return last_match[0],last_match[1]
  end


  def matches_are_paired?(match_first, match_second, line)
    match_text, match_pos = get_match_text_and_pos(match_first)
    next_match_pos = match_second[1]
    end_of_match = match_pos + match_text.key.length
    while end_of_match < next_match_pos
      if line[end_of_match] =~ /\s/
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

  def set_style(csl)
    @csl = csl
  end

  def initialize(path = nil)
    @library = Library.new(path) if path
    @bib_key = /\{papers2_bibliography\}/
    @bibliography = {}
    @styler = Styler.new
  end

  def attach_bibtex_library(library_path)
    @library = BibTeX.open(library_path)
  end

end
