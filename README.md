# Hard Citer 
Hard Citer seeks to replicate the functionality of Papers' [magic citations][1] in
HTML. Papers does not provide an easy way to perform magic citations and 
produce a nicely formatted bibliography for HTML, from an HTML document source.
For the best bang for your buck, use one of the text editors listed [here][2] 
under the heading "Insertation of citekey" so that you can easily cite while you
write. As an added benefit, papers will automatically group your citations in the 
manuscript section. Export this group to a bibtex library and you are ready to 
use Hard Citer.

[1]: http://support.mekentosj.com/kb/tutorials/magic-citations 
[2]: http://support.mekentosj.com/kb/read-write-cite/applications-supported-by-magic-citations 

##Usage
Create a new HardCiter object

```Ruby
citer = HardCiter.new
```

Attach a bibtex library by providing the path to the .bib file

 ```Ruby
citer.attach_bibtex_library("nu.bib")
 ```

Provide the file/string/array with magic citations to the cite_text function

 ```Ruby
file_obj = open("webpage_source.html", "r")
cited_array = citer.cite_text(file_obj)
 ```

The cited_array can then be looped through to output a nicely formatted webpage
with bibliography

 ```Ruby
out_path = "webpage_out.html"
File.open(out_path, 'w') { |f| cited_array.each { |line| f.write(line) } }
 ```



