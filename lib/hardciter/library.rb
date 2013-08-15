# encoding: utf-8
require 'bibtex'
class Library < Hash

  def initialize(path = nil)
    load_lib(path) if path
  end

  def load_lib(path)
    File.open(path, 'r')
  end
end
