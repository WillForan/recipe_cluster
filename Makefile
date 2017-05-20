all: imgs/fullgraph.png

stats: txt/ingredient.list
	tr '\t' '\n' < txt/ingredient.list|sort |uniq -c |sort -nr |head


txt/cookbook_import_pages_current.xml:
	if [ ! -d txt ]; then mkdir txt; fi
	cd txt
	wget http://s3.amazonaws.com/wikia_xml_dumps/c/co/cookbook_import_pages_current.xml.7z
	7z x cookbook_import_pages_current.xml.7z
	rm cookbook_import_pages_current.xml.7z

txt/ingredient.list: parse.pl txt/cookbook_import_pages_current.xml
	./parse.pl txt/cookbook_import_pages_current.xml > txt/ingredient.list 

txt/cormat.txt: mkmat.pl txt/ingredient.list
	./mkmat.pl txt/ingredient.list > cormat.txt

imgs/fullgraph.png: cluster.R txt/cormat.txt
	if [ ! -d imgs ]; then mkdir imgs; fi
	Rscript cluster.R


