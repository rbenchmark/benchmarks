# LogitRegre - Preparing data set for LogitRegression
# 
# Author: Haichuan Wang
#
# Generate the dataset for LogitRegression
#   n: number of samples
#   nvar: number of variables for one sample
#   niter: number of iterations
#   YX: list data, each one is [y x_1 x_2 ... x_nvar]
###############################################################################


setup <- function(args=c('1000000', '10', '50')) {
    n<-as.integer(args[1])
    if(is.na(n)){ n <- 1000000L }
    
    nvar <-as.integer(args[2])
    if(is.na(nvar)){ nvar <- 10L }
    
    niter<-as.integer(args[3])
    if(is.na(niter)){ niter <- 50L }
    
    cat('[INFO][', app.name, '] n=', n, ', nvar=', nvar, ', niter=', niter, '\n', sep='')
    
    X<- matrix(runif(n*nvar, -1, 1), nrow=nvar, ncol=n) 
    theta <- rep(1,nvar)
    Y<- 1/(1+exp(-(1+colSums(theta*X)))) # now the coefficient are all 1
    YX <- lapply(1:n, function(i){c(Y[i],X[,i])})
    list(YX=YX, nvar=nvar, niter=niter);
}