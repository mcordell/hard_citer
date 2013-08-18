# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
Gem::Specification.new do |gem|
  gem.name          = "hard_citer"
  gem.version       = "0.0.3"
  gem.authors       = ["Michael Cordell"]
  gem.email         = ["surpher@gmail.com"]
  gem.description   = %q{
Hard Citer is a solution for outputting HTML bibliographies. When used
in conjuction with a "cite while you write" tool, it can make writing and
editing well-cited html eaiser. This may be particularly useful for 
academics publishing online. Using a in-text cited HTML document and
a bibtex library, it can output a properly formatted bibliography.
}
  gem.summary       = %q{A gem to help with in-text citations in HTML documents.}
  gem.homepage      = "https://github.com/mcordell/hard_citer"
  gem.files         = %w( README.md Rakefile LICENSE.txt )
  gem.files         += Dir.glob("lib/**/*")
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
