# PCA analysis - Direct method with lapply
# 
# Author: Haichuan Wang
###############################################################################
app.name <- 'PCA_lapply'
source('setup_PCA.R')

run <- function(dataset) {
    X <- dataset$X
    
    cross.func <- function(x) {
        tcrossprod(x)
    }
    
    mean.func <- function(x) {
        x
    }

    len <- length(X)
    XC <- Reduce('+', lapply(X, cross.func))
    vMean <- Reduce('+', lapply(X, mean.func)) / len
    
    covM <- XC/len - tcrossprod(vMean)
    eigen(covM)
}

if (!exists('harness_argc')) {
    data <- setup(commandArgs(TRUE))
    run(data)
}
