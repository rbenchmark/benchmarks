
# sparse matrix-vector multiplication
# TODO: sort input by row for perf?

# random 1M x 1M matrix with 10M entries

setup<-function(args='10000000') {
    n<-as.integer(args[1])
    if(is.na(n)){ n=10000000L }
    cat('[smv_builtin]n =', n, '\n')
    library(Matrix)
    
    m <- sparseMatrix(
            as.integer(runif(n, 1, n)),
            sort(as.integer(runif(n, 1, n))),
            x=runif(n),
            dims=c(n,n))
    
    v <- runif(n)
    
    list(m,v)
}

run<-function(dataset){
    m <- dataset[[1]]
    v <- dataset[[2]]
    
    smv <- function(m, v) {
        m %*% v
    }
    #benchpart
    res<-smv(m,v)
    cat(length(res),'\n')
    
}

if (!exists('harness_argc')) {
    dataset <- setup(commandArgs(TRUE))
    run(dataset)
}

