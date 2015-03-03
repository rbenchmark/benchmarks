# LinearRegression-1var - R lm based solution
# 
# Author: Haichuan Wang
###############################################################################
app.name <- 'LR-1var'
source('setup_LR-1var.R')

run <- function(dataset) {
    YX <- dataset$YX
    #grab YX
    vYX <- t(simplify2array(YX))
    
    res <- lm(vYX[,1] ~ vYX[,2]);
    print(res)
}

if (!exists('harness_argc')) {
    data <- setup(commandArgs(TRUE))
    run(data)
}
