# Nearest Neighbor - lapply based implementation
# 
# Author: Haichuan Wang
###############################################################################
app.name <- "NN_lapply"
source('setup_k-NN.R')

run <- function(dataset) {
    
    list_train<-dataset$train_set
    train_n <- length(list_train)
    list_test<-dataset$test_set
    test_n <- length(list_test)
    clusters<- dataset$clusters
    
    #outer loop, map function for each test
    NN.fun <- function(test_item) {
        #calculate the distance to all 
        dists.fun <- function(train_item) {
            sum((train_item$val - test_item$val)^2)
        }
        
        dists <- lapply(list_train, dists.fun)
        #get the which min
        min.train <- which.min(dists)
        #get the category
        test_item$label <- (list_train[[min.train]])$label
        test_item
    }
    
    out_list_test <- lapply(list_test, NN.fun)
    
    #get the cl
    test_cl_vec <- sapply(out_list_test, function(test_item){test_item$label})
    test_cl <- factor(test_cl_vec)
    print(summary(test_cl))
}

if (!exists('harness_argc')) {
    data <- setup(commandArgs(TRUE))
    run(data)
}
