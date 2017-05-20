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

# too many edges to graph -- remove those that are at least 1sd from mean
# not very useful
edgthres <- mean(m[m>0] + .5* sd(m[m>0]))
gsmall<-delete.edges(g, which( E(g)$weight <= edgthres ) )
gsmall$layout <- layout.fruchterman.reingold
V(gsmall)$color <-mem +1
plot(gsmall,mark.groups=com,vertex.size=2, vertex.label=NA) # ,edge.lty="blank"
