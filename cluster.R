library(corrplot)
library(igraph)

# read in matrix (from mkmat.pl, see Makefile)
d<-read.table('txt/cormat.txt',header=T)

# make a matrix,
m.full <- as.matrix(d);

# TODO: dont do this!
# remove  ing. that are used for
#   too few recipies
#   everything (2sd above mean) 
totals <- diag(m.full);  # diagnal has total recipes seen for each ingredient
keep <- totals > 10 & totals < mean(totals)+2*sd(totals)

# restrict and zero identity line
m <- m.full[keep,keep]; diag(m) <- 0


# TODO: rescale weights
#m <- apply(m,1,function(x) scale(x)  )
#m2 <- apply(m,1,function(x) x/mean(x,na.rm=T) ) 
#m<- round( scale(m) , 2)


corrplot(m[1:20,1:20],is.corr=F)

g<-graph_from_adjacency_matrix(m,mode="undirected",weighted=TRUE)
# https://www.sixhat.net/finding-communities-in-networks-with-r-and-igraph.html
fc  <- fastgreedy.community(g)      # FAST, few large clusters
wt  <- walktrap.community(g)        # FAST, many small
sg  <- spinglass.community(g)       # SLOWER, few large 
#ceb <- cluster_edge_betweenness(g)  # SLOW, many small

# which method to use
gcom <- sg 
com <- communities(gcom)
mem <- membership(gcom)


# save graph plot
png('imgs/fullgraph.png')
V(g)$color <- mem + 1
plot(g,mark.groups=com,vertex.size=3, edge.lty="blank",vertex.label=NA) 
dev.off()

## too many edges to graph -- remove those that are at least 1sd from mean
## not very useful
# edgthres <- mean(m[m>0] + .5* sd(m[m>0]))
# gsmall<-delete.edges(g, which( E(g)$weight <= edgthres ) )
# gsmall$layout <- layout.fruchterman.reingold
# V(gsmall)$color <-mem +1
# plot(gsmall,mark.groups=com,vertex.size=2, vertex.label=NA) # ,edge.lty="blank"


## explore clusetrs
# go through each cluster, and for each node lookup the total that ingredient is seen. sort within cluster by seen.
# hint: totals can be accessed by ingredient name: 
#  totals['grape_juice']  # is 12
gettotal  <- function(n) totals[n]
sorttotal <- function(c) sort(decreasing=T, sapply(c,gettotal) )
clustByPopularity <- lapply(com,sorttotal) 

# get only the top 3 from each cluster (and change  'name.name' to 'name')
topofclust <- lapply(clustByPopularity,function(l) gsub('\\..*','',names(head(l,n=5))) )
# add node count as the list item name
names(topofclust ) <- lapply(clustByPopularity,length) 
# ugly hack to "pretty print top clusters
cat(sort(sprintf("%03d\t%s\n",as.numeric(names(topofclust)),lapply(topofclust,paste,collapse=" "))))
#001    sunflower_seeds                                                                                                                        
#003    arrowroot yam grape_juice
#030    ginger peanut sesame_seed firm_tofu sesame_oil
#174    vanilla_extract vanilla baking_powder strawberries margarine
#189    celery oil cilantro basil potato

## if not choping off the top (e.g salt)
#001     arrowroot
#001    currant
#001    double_cream
#002    sauerkraut rye_bread
#190    granulated_sugar water egg butter flour
#225    salt onion garlic tomato olive_oil



