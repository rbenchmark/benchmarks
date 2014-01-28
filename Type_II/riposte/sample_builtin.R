

setup<-function(args='10000000') {
    n<-as.integer(args[1])
    if(is.na(n)){ n=10000000L }
    cat('[sample_builtin]n =', n, '\n')
    n
}


run<-function(n){
    means <- c(0,2,10)
    sd <- c(1,0.1,3)
    
    a <- runif(n)
    i <- floor(runif(n)*3)+1L
    res<-rnorm(n, means[i], sd[i])
    
    cat(length(res),'\n')
}

if (!exists('harness_argc')) {
    dataset <- setup(commandArgs(TRUE))
    run(dataset)
}