module HardCiter
  class Bibliography
    attr_accessor :bibliography_intext, :intext_regex, :bib_out_location, :citation_locations, :citations

    def initialize
      @bibliography_intext = HardCiter::Configuration::BIBLIOGRAPHY_INTEXT_KEY
      @intext_regex = HardCiter::Configuration::INTEXT_REGEX
      @citation_locations = {}
      @citations = {}
    end

    def find_intext_citations(line)
      line.enum_for(:scan, @intext_regex).map do
        match = Regexp.last_match
        pos = match.begin(0)
        [match.to_s, pos]
      end
    end

    def has_bibliography_key?(line)
      line =~ @bibliography_intext
    end

    def mark_match_positions(citation_matches,line,index)
      if citation_matches.length >  1
        @citation_locations[index] = group_matches(citation_matches, line)
      else
        @citation_locations[index] = citation_matches
      end
    end

    def parse_line(line,index)
      @bib_out_location = index if has_bibliography_key?(line)
      regex_matches = find_intext_citations(line) 
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

    def matches_are_paired?(match_first, match_second, line)
      match_text, match_pos = get_match_text_and_pos(match_first)
      next_match_pos = match_second[1]
      end_of_match = match_pos + match_text.key.length
      while end_of_match < next_match_pos
        if line[end_of_match] =~ /\s/
          end_of_match += 1
        else
          false
        end
      end
      true
    end

    def get_match_text_and_pos(match_group)
      if match_group[0].instance_of?(Array)
        #match_group has sub arrays so it needs to be unpacked
        last_match = match_group[match_group.size-1]
      else
        last_match = match_group
      end
      [last_match[0],last_match[1]]
    end
  end
end
