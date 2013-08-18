# Hard Citer 
Hard Citer is a solution for outputting HTML bibliographies. When used in conjuction with a "cite while you write" tool, it can make writing and editing well-cited html eaiser. The default configuration is geared towards usage with Papers' [magic citations][1]. Papers does not provide an easy way to perform magic citations and produce a nicely formatted bibliography for HTML, from an HTML document source.

For the best bang for your buck, use one of the text editors listed [here][2] 
under the heading "Insertation of citekey" so that you can easily cite while you
write. As an added benefit, papers will automatically group your citations in the 
manuscript section. Export this group to a bibtex library and you are ready to 
use Hard Citer.

[1]: http://support.mekentosj.com/kb/tutorials/magic-citations 
[2]: http://support.mekentosj.com/kb/read-write-cite/applications-supported-by-magic-citations 

##Usage

Require the module where you plan on using HardCiter. Initialize a new Citer object by pointing it at the bib file you exported from Papers:

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


