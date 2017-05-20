# Recipe Ingredient Clusters

Cluster ingredients by recipe pairing frequency.


run `make all`; see `Makefile`.

## Data
Recipes from wikia.com.

http://recipes.wikia.com/wiki/Special:Statistics → http://s3.amazonaws.com/wikia_xml_dumps/c/co/cookbook_import_pages_current.xml.7z

## Parse/Preprocess

1. `parse.pl` pulls wiki-linked ingredients (e.g. `[[salt]]`) from the massive xml file into `txt/ingredient.list` with one line per recipe.
2. `mkmat.pl` builds an ingredient by ingredient matrix with a count of how often ingredients are together in a recipe

## Clustering

`cluster.R` tries to group ingredients together in clusters from a graph weighted by the frequency ingredients are featured together in recipes.
