# LinearRegression - R lm based solution
# 
# Author: Haichuan Wang
###############################################################################
app.name <- 'LR'
source('setup_LR.R')

run <- function(dataset) {
    YX <- dataset$YX
    #grab YX
    vYX <- t(simplify2array(YX))
    
    res<-lm(vYX[,1] ~ vYX[,-1]);
    print(res)
}

if (!exists('harness_argc')) {
    data <- setup(commandArgs(TRUE))
    run(data)
}
