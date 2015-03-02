# ICA Analysis - lapply based algorithm
# 
# Author: Haichuan Wang
#
# The code is based on FastICA R package http://cran.r-project.org/web/packages/fastICA/
# Un-mixing n mixed independent uniforms
###############################################################################
app.name <- "ICA_lapply"
source('setup_ica.R')

run <- function(dataset) {
    X <- dataset$X
    A <- dataset$A
    nvar <- dataset$nvar
    niter <- dataset$niter
    n <- length(X) #num of samples

    message("Whitening")
    cross.func <- function(x) {
        tcrossprod(x)
    }
    V <- Reduce('+', lapply(X, cross.func)) / n
    s <- La.svd(V)
    D <- diag(c(1/sqrt(s$d)))
    K <- D %*% t(s$u)
    white.func <- function(x){ K %*% x}
    X1 <- lapply(X, white.func)
    #init W
    W <- matrix(rnorm(nvar^2),nvar, nvar) #init.w
    sW <- La.svd(W)
    W <- sW$u %*% diag(1/sW$d) %*% t(sW$u) %*% W
    W1 <- W
    alpha <- 1
    gwx.fun <- function(x) {
        wx <- W %*% x
        gwx <- tanh(alpha * wx)
        tcrossprod(gwx, x)
    }
    
    g.wx.fun <- function(x) {
        wx <- W %*% x
        gwx <- tanh(alpha * wx)
        alpha * (1 - gwx^2)
    }
    
    ptm <- proc.time() #previous iteration's time
    for(iter in 1:niter) {
        GWX <- lapply(X1, gwx.fun)
        v1 <- Reduce('+', GWX) / n
        G.WX <- lapply(X1, g.wx.fun)
        v2 <- diag(c(Reduce('+', G.WX) / n)) %*% W
        W1 <- v1 - v2
        sW1 <- La.svd(W1)
        W1 <- sW1$u %*% diag(1/sW1$d) %*% t(sW1$u) %*% W1
        W <- W1
        ctm <- proc.time()
        cat("[INFO]Iter", iter, "Time =", (ctm - ptm)[[3]], '\n')
        ptm <- ctm
    }
    #final turn back
    w <- W %*% K
    resA <- t(w) %*% solve(w %*% t(w))
    print(resA)
}

if (!exists('harness_argc')) {
    data <- setup(commandArgs(TRUE))
    run(data)
}
