# Recipe Ingredient Clusters
run `make all`; see `Makefile`.

## Data
recipes from wikia.com.

http://recipes.wikia.com/wiki/Special:Statistics → http://s3.amazonaws.com/wikia_xml_dumps/c/co/cookbook_import_pages_current.xml.7z

## Parse/Preprocess

1. `parse.pl` pulls wiki-linked ingredients are pulled from the massive xml file into `txt/ingredient.list` with one line per recipe.
2. `mkmat.pl` builds an ingredient x ingredient matrix with a count of how often ingredients are together in a recipe

## Clustering

`cluster.R` tries to group ingredients together in clusters from a graph weighted by the frequency ingredients are featured together in recipes.
