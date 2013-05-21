# HardCiter 
Hard Citer seeks to replicate the functionality of Papers' "magic citations" in
HTML. Papers does not provide an easy way to perform magic citations and 
produce a nicely formatted bibliography for HTML, in HTML.

#Usage
Create a new HardCiter object

    citer = HardCiter.new

Attach a bibtex library by providing the path to the .bib file

    citer.attach_bibtex_library("nu.bib")

Provide the file/string/array with magic citations to the cite_text function

    file_obj=open("webpage_source.html","r")
    cited_array=citer.cite_text(file_obj)

The cited_array can then be looped through to output a nicely formatted webpage
with bibliography

    out_path="webpage_out.html"
    File.open(out_path, 'w') { |f| cited_array.each { |line| f.write(line) } }


