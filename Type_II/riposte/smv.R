
# sparse matrix-vector multiplication
# TODO: sort input by row for perf?
# random 1M x 1M matrix with 100M entries

setup<-function(args=c('20000000', '500000')) {
    M <- as.integer(args[1])
    if(is.na(M)){ M=20000000L }

    N <- as.integer(args[2])
    if(is.na(N)){ N=500000L }
    
    cat('[smv]M =', M, 'N =', N, '\n')
    
    v <- runif(N)
    m <- list(
            row=force(sort(as.integer(runif(M, 1, N)))),
            col=force(as.integer(runif(M, 1, N))),
            val=force(runif(M))
    )
    force(v)
    f <- factor(m[[1]]-1L, (1L:N)-1L)
    force(f)
    list(m,v,f)
}


run<-function(dataset){
    m <- dataset[[1]];
    v <- dataset[[2]];
    f <- dataset[[3]];
    
    smv <- function(m, v, f) {
        lapply(split(m[[3]]*v[m[[2]]], f), "sum")
    }
    #benchpart;
    res<-smv(m,v,f);
    cat(length(res),'\n');
}

if (!exists('harness_argc')) {
    dataset <- setup(commandArgs(TRUE))
    run(dataset)
}
