# k-means-1D - lapply based implementation
# 
# Author: Haichuan Wang
#
# k-means-1D using lapply based iterative algorithm
###############################################################################
app.name <- "k-means-1D_lapply"
source('setup_k-means-1D.R')

run <- function(dataset) {
    ncluster <- dataset$ncluster
    niter <- dataset$niter
    Points <- dataset$Points
    
    centers <- Points[1:ncluster] #pick 10 as default centers
    size <- integer(ncluster);
    
    dist.func <- function(ptr){
        dist.inner.func <- function(center){
                              (ptr-center)^2
                           }
        lapply(centers, dist.inner.func)
    }
    
    ptm <- proc.time() #previous iteration's time
    for(iter in 1:niter) {
        #map each item into distance to 10 centers.
        dists <- lapply(Points, dist.func)
        ids <- lapply(dists, which.min);
        #calculate the new centers through mean
        for(j in 1:ncluster) {
            cur_cluster <- Points[ids==j]
            size[j] <- length(cur_cluster)
            centers[[j]] <- Reduce('+', cur_cluster) / size[j]
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
