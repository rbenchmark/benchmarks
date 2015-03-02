# ICA Analysis - fastICA package
# 
# Author: Haichuan Wang
#
# The code is based on FastICA R package http://cran.r-project.org/web/packages/fastICA/
# Un-mixing n mixed independent uniforms using fastICA package
###############################################################################
app.name <- "ICA_fastICA"
source('setup_ica.R')
library(fastICA)

run <- function(dataset) {
    X <- dataset$X
    A <- dataset$A
    nvar <- dataset$nvar
    niter <- dataset$niter
    n <- length(X) #num of samples
    
    X <- t(simplify2array(X))
    res <- fastICA(X, nvar, alg.typ = "parallel", fun = "logcosh", alpha = 1,
            method = "R", row.norm = FALSE, maxit = niter, tol = 0.0001,
            verbose = TRUE)
    print(res$A)
}

if (!exists('harness_argc')) {
    data <- setup(commandArgs(TRUE))
    run(data)
}