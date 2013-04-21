require 'library'
class Citer
  @@library=nil


  def parse_sentence(sentence)
    regexp=/\{(\w*:\w*)\}/
    y=sentence.enum_for(:scan, regexp).map do
      match=Regexp.last_match
      pos=match.begin(0)
      [match.to_s,pos]
    end
  end
  


  def find_citations (text)
    if text.is_a?(String)
      text=text
    elsif text_is_a?(Array)
      text=text.join
    end
  end

  def initialize( path=nil )
    #Create Citer object
    if path
      @@library=Library.new(path)
    end
  end

  def set_lib(library_in)
    @@library=library_in
  end
  
  def parse_citations(text_in)

  end

  def parse_from_file(path)
    lines=load_file(path)

  end

  def find_blocks(lines)
    r=Regexp.compile('\{.*\}')
    line_count=0
    lines.each do 
      |line|
      matches=r.match(all_lines)
      matches.each { |match| puts "Line # #{line_count}: #{match}" }
      line_count += 1
    end
  end

  def find_blocks_manually(lines)
    line_count=0
    pairs=[]
    open_blocks = []
    lines.each do
        |line|
        char_line_count=0
        line.each_char do
          |c|
          if c.eql?("{")
            open_blocks.push([line_count,char_line_count])
          elsif c.eql?("}") && open_blocks.empty?
            puts "Un-openend close found at Line Num = #{line_count}, "+
                                            "Char_num= #{char_line_count}" 
          elsif c.eql?("}") && open_blocks.any?
            opening=open_blocks.pop
            puts "Block at opening: LN=#{opening[0]} CN=#{opening[1]}"
            puts "Block closed at: LN=#{line_count} CN=#{char_line_count}"
          end
          char_line_count+=1
        end
        line_count+=1
    end
  end

  private
    def load_file(path)
      ### Helper file for loading and reading a text file
      f= File.open(path,'r')
      lines=f.readlines
      return lines
    end
end

if __FILE__ == $0
  x = Citer.new
  x.parse_sentence "Hey man this is a sentence with a citation at the end {Wasmuth:2000vj}{Sellmeyer:2001tn}."
end
