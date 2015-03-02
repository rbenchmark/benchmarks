# k-means-1D - vector programming based implementation
# 
# Author: Haichuan Wang
#
# k-means-1D using vector programming
###############################################################################
app.name <- "k-means-1D_vec"
source('setup_k-means-1D.R')
library(vecapply)

run <- function(dataset) {
    ncluster <- dataset$ncluster
    niter <- dataset$niter
    Points <- dataset$Points
    vPoints <- simplify2array(Points)
    
    centers <- vPoints[1:ncluster] #pick 10 as default centers
    size <- integer(ncluster)
    ptm <- proc.time() #previous iteration's time
    for(iter in 1:niter) {
        #map each item into distance to 10 centers.
        #tmp_centers <- t(matrix(rep(centers, length(data)), ncol=length(data)))
        #dists <- (data -tmp_centers)^2
        
        dists <- outer(vPoints, centers, function(x,y){(x-y)^2})
        ids <- apply(dists, 1, which.min);
        #calculate the new centers through mean
        for(j in 1:ncluster) {
            cur_cluster <- vPoints[ids==j]
            size[j] <- length(cur_cluster)
            centers[j] <- mean(cur_cluster)
        }
        ctm <- proc.time()
        cat("[INFO]Iter", iter, "Time =", (ctm - ptm)[[3]], '\n')
        ptm <- ctm
    }
    #calculate the distance to the 10 centers
    
    cat("Centers:\n")
    print(sort(centers));
    cat("Sizes:\n")
    print(size);
}

if (!exists('harness_argc')) {
    data <- setup(commandArgs(TRUE))
    run(data)
}
