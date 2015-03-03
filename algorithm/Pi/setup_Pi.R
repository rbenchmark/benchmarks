# Monte-Carlo Pi - Preparing data set for Pi calculation
# 
# Author: Haichuan Wang
#
# Generate the dataset for Pi
#   n: number of samples
###############################################################################

setup <- function(args=c('20000000')) {
    n<-as.integer(args[1])
    if(is.na(n)){ n <- 20000000L }
    
    cat('[INFO][', app.name, '] n=', n, '\n', sep='')
    
    rdata <- runif(n*2) 
    S <- lapply(1:n, function(i){rdata[(2*i-1):(2*i)]})
    
    S
}