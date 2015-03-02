# k-means-1D - Preparing dataset for k-means-1D
#
# Author: Haichuan Wang
# 
# Generate the dataset for k-means
#   n: number of the points
#   ncluster: number of the clusters
#   niter: number of the iterations
#   Points: the samples
###############################################################################

setup <- function(args=c('1000000', '10', '15')) {
    n<-as.integer(args[1])
    if(is.na(n)){ n <- 1000000L }
    
    ncluster<-as.integer(args[3])
    if(is.na(ncluster)){ ncluster <- 10L }
    
    niter<-as.integer(args[3])
    if(is.na(niter)){ niter <- 15L }
    
    cat('[INFO][', app.name, '] n=', n, ', ncluster=', ncluster, ', niter=', niter, '\n', sep='')
    
    #the data, each is
    mean_shift <- rep(0:(ncluster-1), length.out = n)
    Points <- rnorm(n, sd = 0.3) + mean_shift
    Points <- lapply(1:n, function(i){Points[i]})
    
    return(list(Points=Points, ncluster=ncluster, niter=niter))
}