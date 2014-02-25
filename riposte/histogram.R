
#data <- sample(1:100, 100000, replace=TRUE)

setup<-function(args='100000000') {
    n<-as.integer(args[1])
    if(is.na(n)){ n=10000000L }
    cat('[historgram]n =', n, '\n')
    data <- as.integer(runif(n,0,100))
    f <- factor(data, 0L:99L)

}

run<-function(data) {
    #the below 2 are commented in org benchmark
    #f <- factor(data, 0L:99L);
    #lapply(split(data,f), "length")
    #bench part
    r<-tabulate(data,100L);
    cat(length(r),'\n')
}


if (!exists('harness_argc')) {
    dataset <- setup(commandArgs(TRUE))
    run(dataset)
}