# PCA Analysis - Preparing data set for PCA analysis
# 
# Author: Haichuan Wang
#
# Generate the dataset for PCA
#   nvar: number of signals of PCA
#   n: number of samples
###############################################################################


setup <- function(args=c('1000000', '10')) {
    n<-as.integer(args[1])
    if(is.na(n)){ n <- 1000000L }
    
    nvar <-as.integer(args[2])
    if(is.na(nvar)){ nvar <- 10L }
    
    cat('[INFO][', app.name, '] n=', n, ', nvar=', nvar, '\n', sep='')
    
    X <- matrix(runif(n*nvar, 0, 10), nrow=nvar, ncol=n) 
    X <- lapply(1:n, function(i){X[,i]})
    list(X = X)
}