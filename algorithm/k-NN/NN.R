# Nearest Neighbor - R built-in knn1 based implementation
# 
# Author: Haichuan Wang
###############################################################################
app.name <- "NN"
source('setup_k-NN.R')
library(class) #use built-in knn

run <- function(dataset) {

    list_train<-dataset$train_set
    train_n <- length(list_train)
    list_test<-dataset$test_set
    test_n <- length(list_test)
    clusters<- dataset$clusters
    
    #change list_train into matrix
    train <- t(sapply(list_train, function(item){item$val}))
    train_cl <- factor(sapply(list_train, function(item){item$label}))
    test <- t(sapply(list_test, function(item){item$val}))
    test_cl <- knn1(train, test, train_cl)

    #the raw data
    test_labels <- attr(test_cl, "levels")
    #finally change the test data to attach the label
    out_list_test <- lapply(1:test_n, function(i){
                                 item<-list_test[[i]]
                                 item$label<- test_labels[test_cl[i]]
                                 item
                             })
    print(summary(test_cl))
}

if (!exists('harness_argc')) {
    data <- setup(commandArgs(TRUE))
    run(data)
}
