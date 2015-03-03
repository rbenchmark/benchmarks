# LogitRegre - lapply based algorithm (from SparkR)
# 
# Author: Haichuan Wang
###############################################################################
app.name <- 'LogitRegre2_lapply'
source('setup_LogitRegre.R')

run <- function(data) {
    YX <- data$YX
    nvar <- data$nvar
    niter<-data$niter
    
    #X includes "1" column, Y column vec
    grad.func <- function(yx) {
        y <- yx[1]
        x <- yx[-1]
        dot <- sum(x * w)
        logit <- 1 / (1 + exp(-y * dot))
        x * ((logit - 1) * y)
    }
    
    # Initialize w to a random value
    w <- double(nvar) #runif(n=nvar, min = -1, max = 1)
    cat("Initial w: ", w, "\n")
    
    ptm <- proc.time() #previous iteration's time
    for(iter in 1:niter) {
        w <- w - Reduce('+', lapply(YX, grad.func))
        ctm <- proc.time()
        cat("[INFO]Iter", iter, "Time =", (ctm - ptm)[[3]], '\n')
        ptm <- ctm
        cat("w = ", w, "\n")
    }
    cat("Final w: ", w, "\n")
}


if (!exists('harness_argc')) {
    data <- setup(commandArgs(TRUE))
    run(data)
}
