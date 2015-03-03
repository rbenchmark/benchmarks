# LinearRegression - Preparing data set for Linear Regression
# 
# Author: Haichuan Wang
#
# Generate the dataset for LogitRegression
#   n: number of samples
#   niter: number of iterations
#   YX: list data, each one is [y x]
###############################################################################


setup <- function(args=c('1000000', '50')) {
    n<-as.integer(args[1])
    if(is.na(n)){ n <- 1000000L }
    
    niter<-as.integer(args[2])
    if(is.na(niter)){ niter <- 50L }
    
    cat('[INFO][', app.name, '] n=', n, ', niter=', niter, '\n', sep='')
    
    X<- runif(n, 0, 10) 
    Y<- X + rnorm(n) + 1
    YX <- lapply(1:n, function(i){c(Y[i],X[i])})
    list(YX=YX, niter=niter)
}