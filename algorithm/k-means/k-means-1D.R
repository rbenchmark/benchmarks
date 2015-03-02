# k-means-1D - R internal k-means based implementation
# 
# Author: Haichuan Wang
#
# k-means-1D using R built-in k-means implementation
###############################################################################
app.name <- "k-means-1D"
source('setup_k-means-1D.R')

run <- function(dataset) {
    ncluster <- dataset$ncluster
    niter <- dataset$niter
    Points <- dataset$Points
    vPoints <- simplify2array(Points)
    
    res<-kmeans(vPoints, ncluster, iter.max=niter);
    cat("Centers:\n")
    print(res$centers);
    cat("Sizes:\n")
    print(res$size);
}

if (!exists('harness_argc')) {
    data <- setup(commandArgs(TRUE))
    run(data)
}
