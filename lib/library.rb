require 'bibtex'
class Library < Hash

  def initialize(path=nil)

    if path
      load_lib(path)
    end
  end

  def load_lib(path)
    File.open(path,'r')
  end
end
