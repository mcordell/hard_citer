module HardCiter
  class Citer
    BIBTEX_LIBRARY_REGEX = /\.bib$/
    attr_accessor :library, :styler, :csl, :bibliography

    #Citer
    def initialize(path = nil)
      initialize_library_by_path(path) if path
      @bibliography = HardCiter::Bibliography.new
      @styler = HardCiter::Styler.new
      @csl = HardCiter::Configuration::CSL
    end

    #Citer
    def initialize_library_by_path(path)
      if path =~ BIBTEX_LIBRARY_REGEX
        @library = BibTexLibrary.new(path)
      else
        raise "Unknown path type"
      end
    end

    #Citer
    def cite_text(text)
      validate_prerequisites 
      doc = Document.new(text)
      find_all_citations(doc.text_array) #move this from bib to doc? TODO
      output_text = integrate_citations_into_text(doc.text_array)
      output_text = integrate_bibliography_into_text(output_text)
    end

    def validate_prerequisites
      if @bibliography.nil?
        raise "Bibliography missing cannot proceed with citation"
      elsif @csl.nil?
        raise "No citation format found, cannot proceed with citation"
      end
    end

    #Citer
    #refactor to use Document
    def find_all_citations(text)
      text.each_with_index() do |line, index|
        regex_matches = @bibliography.parse_line(line,index)
        matches = regex_matches_to_cite_matches(regex_matches) unless regex_matches.empty?
        @bibliography.mark_match_positions(matches,line,index) unless matches.nil?        
      end
    end

    def regex_matches_to_cite_matches(regex_matches)
      regex_matches.map { |m| get_or_create_cite_match(m) }
    end

    # Document, Bib
    def integrate_citations_into_text(text)
      output_text = text.dup
      @bibliography.citation_locations.each do |line_number,cite_matches|
        text_line = output_text[line_number]
        output_text[line_number] = @styler.style_line(text_line,cite_matches)
      end
      output_text
    end

    #
    def integrate_bibliography_into_text(text)
      out_location = @bibliography.bib_out_location
      if out_location
        bib_text = styler.get_bibliography_lines(@bibliography, @csl)
        bib_end = out_location + 1
        after_bib_location = text[(bib_end..text.size-1)]
        return text[0..bib_end] + bib_text + after_bib_location
      else
        warn('No bib key found. \
             Bibliography not added to cited text.')
        return text
      end
    end

    def get_or_create_cite_match(regex_match)
      match_key, match_pos = regex_match

      if @bibliography.citations.has_key?(match_key)
        cite_match = @bibliography.citations[match_key]
      else
        cite_match = CiteMatch.new(match_key)
        cite_match.bib_number = @bibliography.citations.length + 1
        cite_match.citation = @library.get_citation(convert_match_to_cite_key(match_key))
        @bibliography.citations[match_key] = cite_match
      end
      [cite_match, match_pos]
    end

    def convert_match_to_cite_key(match)
      match.gsub(/\{|\}/, '')
    end
  end
end
