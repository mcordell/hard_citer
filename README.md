# Hard Citer[![Gem Version](https://badge.fury.io/rb/hard_citer.png)](http://badge.fury.io/rb/hard_citer)[![Coverage Status](https://coveralls.io/repos/mcordell/hard_citer/badge.png?branch=master)](https://coveralls.io/r/mcordell/hard_citer?branch=master)

Hard Citer is a solution for outputting HTML bibliographies. When used in conjuction with a "cite while you write" tool, it can make writing and editing well-cited html eaiser. Using a in-text cited HTML document and a bibtex library, it can output a properly formatted bibliography. The default configuration is geared towards usage with Papers' [magic citations][1]. Papers does not provide an easy way to perform magic citations and produce a nicely formatted bibliography for HTML, from an HTML document source.

For the best bang for your buck, use one of the text editors listed [here][2] 
under the heading "Insertation of citekey" so that you can easily cite while you
write. As an added benefit, papers will automatically group your citations in the 
manuscript section. Export this group to a bibtex library and you are ready to 
use Hard Citer.

[1]: http://support.mekentosj.com/kb/tutorials/magic-citations 
[2]: http://support.mekentosj.com/kb/read-write-cite/applications-supported-by-magic-citations 

##Usage

Install the hard_citer gem and require it.

```Ruby
require 'hard_citer'
```

Initialize a new Citer object by pointing it at the bib file you exported from Papers:

```Ruby
require File.expand_path("../lib/hard_citer", __FILE__)
citer = HardCiter::Citer.new('./examples/example_bib.bib')
```

Open the HTML file that contains the intext citations that match the bib file.

```Ruby
input_html = File.open('./examples/example_input.html','r')
```

Now, simply provide the input_html to the cite_text function and it will return the well-cited output text.

```Ruby
html_output = citer.cite_text()
```


You can change the output format of the citations by changing the CSL of the citer object before calling cite_text. Simply provide the path to the csl file that you would like to use.

```Ruby
citer.csl = File.expand_path("../examples/plos.csl")
```


##TODO
Here is a general list of how I would like to improve this gem

1. Command line commands in conjunction with a yml configuration file
2. Better support for alternate CWYW tools
3. More Tests 
4. Expand the Library function so that you can use ActiveRecords or kin for easier rails support


##Contact

I would love to hear from anyone who would like me to improve this gem or who has comments and suggestions. 

\[[Twitter](https://twitter.com/mike_cordell)\] | \[[Email](mailto:mike@mikecordell.com)\] | \[[Website](http://www.mikecordell.com)\] 
