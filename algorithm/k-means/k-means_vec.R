# k-means - vector programming based implementation
# 
# Author: Haichuan Wang
#
# k-means using vector programming
###############################################################################

app.name <- "k-means_vec"
source('setup_k-means.R')
library(vecapply)

run <- function(dataset) {
    ncluster <- dataset$ncluster
    niter <- dataset$niter
    Points <- dataset$Points
    vPoints <- t(simplify2array(Points)) # n * ndim matrix
    
    centers <- vPoints[1:ncluster, ] #pick 10 as default centers
    size <- integer(ncluster);
    n <- nrow(vPoints)
    dists <- matrix(0, nrow=n, ncol=ncluster) #pre-allocate memory
    ptm <- proc.time() #previous iteration's time
    for(iter in 1:niter) {
        #need calculate each points' distance to all centers
        #try to use vec as much as possible
        for(j in 1:ncluster) {
            center_expand <- matrix(rep(centers[j,], each=n), n, 3)
            dists[,j] = rowSums((vPoints - center_expand)^2)
        }
        #map each item into distance to 10 centers.
        ids <- apply(dists, 1, which.min)
        #calculate the new centers through mean
        for(j in 1:ncluster) {
            cur_cluster <- vPoints[ids==j, ]
            size[j] <- nrow(cur_cluster)
            centers[j,] <- colMeans(cur_cluster)
        }
        ctm <- proc.time()
        cat("[INFO]Iter", iter, "Time =", (ctm - ptm)[[3]], '\n')
        ptm <- ctm
    }
    #calculate the distance to the 10 centers
    
    cat("Centers:\n")
    print(centers);
    cat("Sizes:\n")
    print(size);
}

if (!exists('harness_argc')) {
    data <- setup(commandArgs(TRUE))
    run(data)
}
