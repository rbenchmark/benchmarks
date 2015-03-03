# LogitRegre-1var - Preparing data set for LogitRegression 1 variable case
# 
# Author: Haichuan Wang
#
# Generate the dataset for LogitRegression
#   n: number of samples
#   niter: number of iterations
#   YX: list data, each one is [y x_1 x_2 ... x_nvar]
###############################################################################


setup <- function(args=c('1000000', '50')) {
    n<-as.integer(args[1])
    if(is.na(n)){ n <- 1000000L }
    
    niter<-as.integer(args[3])
    if(is.na(niter)){ niter <- 50L }
    
    cat('[INFO][', app.name, '] n=', n, ', niter=', niter, '\n', sep='')
        
    X<- runif(n, 0, 10)  
    Y<- 1/(1+exp(-(1+X))) + rnorm(n) * 0.05 # now the coefficient is 1
    YX <- lapply(1:n, function(i){c(Y[i],X[i])})
    list(YX=YX, niter=niter);
    
}