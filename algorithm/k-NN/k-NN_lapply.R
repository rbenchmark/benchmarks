# k Nearest Neighbor - lapply based implementation
# 
# Author: Haichuan Wang
###############################################################################
app.name <- "k-NN_lapply"
source('setup_k-NN.R')

run <- function(dataset) {
    list_train<-dataset$train_set
    train_n <- length(list_train)
    list_test<-dataset$test_set
    test_n <- length(list_test)
    clusters<- dataset$clusters
    k <- dataset$k
    
    #outer loop, map function for each test
    kNN.fun <- function(test_item) {
        #calculate the distance to all 
        dists.fun <- function(train_item) {
            sum((train_item$val - test_item$val)^2)
        }
        
        dists_list <- lapply(list_train, dists.fun)
        #change to dists_vec, and do the sorting
        dists <- unlist(dists_list)
        
        mink.indices <-order(dists)
        #then should pick the first k items, find t
        train_items_indices <- mink.indices[1:k]

        train_items_category <- character(k)
        for(i in 1:k) {
          train_items_category[i] <- list_train[[train_items_indices[i]]]$label
        }
        
        #now get the their label and vote
        test_item$label <- names(which.max(table(train_items_category)))
        test_item
    }
    
    ptm <- proc.time() #previous iteration's time
    out_list_test <- lapply(list_test, kNN.fun)
    
    
    #get the cl
    test_cl <- lapply(out_list_test, function(test_item){test_item$label})
    test_cl <- factor(unlist(test_cl))
    cat("[INFO]Time =", (proc.time()-ptm)[[3]], '\n')
    print(summary(test_cl))
}


if (!exists('harness_argc')) {
    data <- setup(commandArgs(TRUE))
    run(data)
}