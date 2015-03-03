# k-NN/NN - Preparing data set for k-NN/NN
# 
# Author: Haichuan Wang
#
# Generate the dataset for k-NN
#   train_n: number of train samples
#   teats_n: number of test samples
#   ncluster: how many ncluster
#   A: Mixing matrix 
#   niter: number of iterations of the ICA algorithm
###############################################################################


setup <- function(args=c('10000', '10000', '10', '5')) {
    train_n<-as.integer(args[1])
    if(is.na(train_n)){ train_n <- 10000L }
    
    test_n<-as.integer(args[2])
    if(is.na(test_n)){ test_n <- 10000L }   
    
    ncluster<-as.integer(args[3])
    if(is.na(ncluster)){ ncluster <- 10L }
    
    k<-as.integer(args[4])
    if(is.na(k)){ k <- 5L }    
    
    cat('[INFO][', app.name, '] train_n=', train_n, ', test_n=', test_n, ', ncluster=', ncluster, ', k=', k, '\n', sep='')
    
    #generate training
    mean_shift <- rep(0:(ncluster-1), length.out = 3*train_n)
    train_set <- matrix(rnorm(3*train_n, sd = ncluster/2) + mean_shift, ncol=3)
    list_train_set <- lapply(1:train_n, function(i) {
                label_str <-paste('C', as.character(mean_shift[i]), sep="")
                list(val=train_set[i,], label=label_str)
            })
    
    test_set <- matrix(runif(3*test_n, min=-ncluster, max=2*ncluster-1), ncol=3)
    list_test_set <- lapply(1:test_n, function(i) {
                list(val=test_set[i,])
            })
    
    list(train_set=list_train_set, 
         test_set=list_test_set,
         ncluster=ncluster,
         k=k)
}