# LinearRegression-1var - LMS(least mean square) vector programming based solution
# 
# Author: Haichuan Wang
###############################################################################
app.name <- 'LR-1var_lms_vec'
source('setup_LR-1var.R')

run <- function(dataset) {
    YX <- dataset$YX
    niter <- dataset$niter
    vYX <- t(simplify2array(YX))
    X <- cbind(1, matrix(vYX[,2]))
    Y <- vYX[,1]
    
    #X includes "1" column, Y column vec
    grad.func <- function(X, y) {
        error <- (X %*% theta - y)
        #This is a simple normalization
        delta <- t(X) %*% error / length(y)
        return(delta)
    }
    
    cost <- function(X, y, theta) {
        # computes the cost of using theta as the parameter for linear regression
        # to fit the data points in X and y
        sum((X %*% theta - y)^2)/(2 * length(y))
    }
    

    theta <- double(ncol(X)) #initial guess
    alpha <- 0.05 # small step

    ptm <- proc.time() #previous iteration's time
    for(iter in 1:niter) {
        delta <- grad.func(X, Y)
        #cat('delta =', delta, '\n')
        theta <- theta - alpha * delta
        ctm <- proc.time()
        cat("[INFO]Iter", iter, "Time =", (ctm - ptm)[[3]], '\n')
        ptm <- ctm
        cat('theta =', theta, '\n')
        #print(cost(X,y, theta))
    }
    cat('Final theta =', theta, '\n')
}

if (!exists('harness_argc')) {
    data <- setup(commandArgs(TRUE))
    run(data)
}
