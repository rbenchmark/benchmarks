# ICA Analysis - Preparing data set for ICA analysis
# 
# Author: Haichuan Wang
#
# Generate the dataset for ICA
#   nvar: number of signals of ICA unmixing
#   n: number of samples
#   X: list of samples, each sample is a length nvar size double vector
#   A: Mixing matrix 
#   niter: number of iterations of the ICA algorithm
###############################################################################


setup <- function(args=c('1000000', '2', '25')) {
    n<-as.integer(args[1])
    if(is.na(n)){ n <- 1000000L }
    
    nvar <-as.integer(args[2])
    if(is.na(nvar)){ nvar <- 2L }
    
    niter<-as.integer(args[3])
    if(is.na(niter)){ niter <- 25L }
    
    cat('[INFO][', app.name, '] n=', n, ', nvar=', nvar, ', niter=', niter, '\n', sep='')
    
    #generate pre-centered data. Note the data shape is n x nvar
    S <- matrix(runif(n*nvar), nrow=n, ncol=nvar)
    A <- matrix(c(1, 1, -1, 3), 2, 2)
    X <- scale(S %*% A, scale = FALSE) #pre-centering
    X <- lapply(1:n, function(i){X[i,]})
    list(X = X, A = A, nvar=nvar, niter = niter)
}
