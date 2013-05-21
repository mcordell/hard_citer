# HardCiter 
Hard Citer seeks to replicate the functionality of Papers' "magic citations" in
HTML. Papers does not provide an easy way to perform magic citations and 
produce a nicely formatted bibliography for HTML, in HTML.

##Usage
Create a new HardCiter object

{% highlight ruby %}
    citer = HardCiter.new
{% endhighlight %}
Attach a bibtex library by providing the path to the .bib file

{% highlight ruby %
    citer.attach_bibtex_library("nu.bib")
{% endhighlight %}

Provide the file/string/array with magic citations to the cite_text function

{% highlight ruby %
    citer.attach_bibtex_library("nu.bib")
    file_obj = open("webpage_source.html", "r")
    cited_array = citer.cite_text(file_obj)
{% endhighlight %}

The cited_array can then be looped through to output a nicely formatted webpage
with bibliography

{% highlight ruby %
    citer.attach_bibtex_library("nu.bib")
    out_path = "webpage_out.html"
    File.open(out_path, 'w') { |f| cited_array.each { |line| f.write(line) } }
{% endhighlight %}


