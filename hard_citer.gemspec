# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
Gem::Specification.new do |gem|
  gem.name          = "hard_citer"
  gem.version       = "0.0.2"
  gem.authors       = ["Michael Cordell"]
  gem.email         = ["surpher@gmail.com"]
  gem.description   = %q{
Hard Citer seeks to replicate the functionality of Papers' magic citations in
HTML. Papers does not provide an easy way to perform magic citations and 
produce a nicely formatted bibliography for HTML, from an HTML document source.
For the best bang for your buck, use one of the text editors listed here 
under the heading "Insertation of citekey" so that you can easily cite while you
write. As an added benefit, papers will automatically group your citations in the 
manuscript section. Export this group to a bibtex library and you are ready to 
use Hard Citer.}
  gem.summary       = %q{A gem to replicate the functionality of paper's magic citations.}
  gem.homepage      = "https://github.com/mcordell/hard_citer"

  gem.files         = %w( README.md Rakefile LICENSE.txt )
  gem.files         += Dir.glob("lib/**/*")
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
