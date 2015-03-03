# LogitRegre-1var - lapply based algorithm with vecapply
# 
# Author: Haichuan Wang
###############################################################################
app.name <- 'LogitRegre-1var_lapply_cmp'
source('setup_LogitRegre-1var.R')
library(vecapply)

run <- function(dataset) {  
    YX <- dataset$YX
    niter<-data$niter
    
    theta <- double(length(YX[[1]])) #initial guess as 0
    
    #X includes "1" column, Y column vec
    grad.func <- function(yx) {
        y <- yx[1]
        x <- c(1, yx[2])
        logit <- 1/(1 + exp(-sum(theta*x)))
        (y-logit) * x
    }
    
    ptm <- proc.time() #previous iteration's time
    for(iter in 1:niter) {
        delta <- lapply(YX, grad.func)
        #cat('delta =', delta, '\n')
        theta <- theta + Reduce('+', delta) / length(YX)
        ctm <- proc.time()
        cat("[INFO]Iter", iter, "Time =", (ctm - ptm)[[3]], '\n')
        ptm <- ctm
        cat('theta =', theta, '\n')
        #print(cost(X,y, theta))
    }
    cat('Final theta =', theta, '\n')
}

run <- va_cmpfun(run)

if (!exists('harness_argc')) {
    data <- setup(commandArgs(TRUE))
    run(data)
}
