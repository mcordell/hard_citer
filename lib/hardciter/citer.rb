module HardCiter
  class Citer

    attr_accessor :library, :output, :csl, :bibliography

    def initialize(path = nil)
      initialize_library_by_path(path) if path
      @bibliography = HardCiter::Bibliography.new
      @csl = HardCiter::Configuration::CSL
      @output = HardCiter::HtmlOutput.new(@csl)
      @parser = HardCiter::Parser.new
    end

    def initialize_library_by_path(path)
      if path =~ HardCiter.configuration.bibtex_library_regex
        @library = BibTexLibrary.new(path)
      else
        raise "Unknown library path type"
      end
    end

    def cite_text(text)
      validate_prerequisites
      document = Document.new(text)
      intext_matches = parse_all_lines(document)
      add_and_group_intext_matches(document, intext_matches)
      get_entries_from_library
      @output.prepare_bibliography(@bibliography)
      @output.process_and_output_text(document,intext_matches)
    end

    def get_entries_from_library
        raise "Library is not set. Cannot get entries." if @library.nil?
        raise "Bibliography is not set. Cannot get entries." if @bibliography.nil?
        raise "Bibliography has no citations" if @bibliography.citations.nil? || @bibliography.citations.empty?
        @bibliography.citations.each do |cite_key,citation|
          citation.entry = @library.get_entry(citation.key)
        end
    end

    def add_and_group_intext_matches(document,intext_matches)
      intext_matches.each_with_index do |matches, index|
        line = document.text_array[index]
        matches.each do |match|
          citation = @bibliography.pair_match_to_citation(match,index)
          match.citation = citation if citation
        end
        group_matches!(matches,line)
      end
    end

    def validate_prerequisites
      if @library.nil?
        raise "Library missing cannot proceed with citation"
      elsif @csl.nil?
        raise "No citation format found, cannot proceed with citation"
      end
    end

    def parse_all_lines(document)
      document.text_array.each_with_object([]) do |line,out|
        out.push(@parser.parse_line(line))
      end
    end

    def group_matches!(matches, line)
      temp_matches = []
      current_match = matches.shift unless matches.empty?
      head = current_match
      until matches.empty?
        next_match = matches.shift
        if matches_are_paired?(current_match, next_match, line)
          pair_matches(current_match,next_match)
        else
          temp_matches.push(head)
          head = next_match
        end
        current_match = next_match
      end
      temp_matches.each { |m| matches.push m }
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
