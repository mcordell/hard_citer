module HardCiter
  class Citer
    
    attr_accessor :library, :styler, :csl, :bibliography

    #Citer
    def initialize(path = nil)
      initialize_library_by_path(path) if path
      @bibliography = HardCiter::Bibliography.new
      @styler = HardCiter::Styler.new
      @csl = HardCiter::Configuration::CSL
      @parser = HardCiter::Parser.new
    end

    #Citer
    def initialize_library_by_path(path)
      if path =~ HardCiter.configuration.bibtex_library_regex
        @library = BibTexLibrary.new(path)
      else
        raise "Unknown library path type"
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
      if @library.nil?
        raise "Library missing cannot proceed with citation"
      elsif @csl.nil?
        raise "No citation format found, cannot proceed with citation"
      end
    end

    #Citer
    #refactor to use Document
    def find_all_citations(text)
      text.each_with_index() do |line, index|
        regex_matches = @bibliography.parse_line(line,index)
        matches = regex_matches_to_citations(regex_matches) unless regex_matches.empty?
        @bibliography.mark_match_positions(matches,line,index) unless matches.nil?        
      end
    end

    def parse_all_lines(document)
      document.text_array.each_with_object([]) do |line,out|
        out.push(@parser.parse_line(line))
      end
    end

    def regex_matches_to_citations(regex_matches)
      regex_matches.map { |m| get_or_create_citation(m) }
    end

    # Document, Bib
    def integrate_citations_into_text(text)
      output_text = text.dup
      @bibliography.citation_locations.each do |line_number,citations|
        text_line = output_text[line_number]
        output_text[line_number] = @styler.style_line(text_line,citations)
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

    def get_or_create_citation(regex_match)
      match_key, match_pos = regex_match

      if @bibliography.citations.has_key?(match_key)
        citation = @bibliography.citations[match_key]
      else
        citation = Citation.new(match_key)
        citation.bib_number = @bibliography.next_citation_index
        citation.citation = @library.get_citation(convert_match_to_cite_key(match_key))
        @bibliography.citations[match_key] = citation
      end
      [citation, match_pos]
    end

    def convert_match_to_cite_key(match)
      match.gsub(/\{|\}/, '')
    end

    def group_matches!(matches, line)
      out_matches = []
      current_match = matches.shift unless matches.empty?
      head = current_match
      until matches.empty?
        next_match = matches.shift
        if matches_are_paired?(current_match, next_match, line)
          pair_matches(current_match,next_match)
        else
          out_matches.push(head)
          head = next_match
        end
        current_match = next_match
      end
      out_matches.each { |m| matches.push m }
      matches.push(head)
    end

    private
      def matches_are_paired?(match_first, match_second, line)
        end_of_match = match_first.position + match_first.regex_match.length
        while end_of_match < match_second.position
          if line[end_of_match] =~ /\s/
            end_of_match += 1
          else
            return false
          end
        end
        return true
      end

      def pair_matches(first_match, second_match)
        first_match.next_in_group = second_match
      end

  end
end
