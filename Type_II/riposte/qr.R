
setup<-function(args='1000'){

    #m <- c(1,2,3,4,5,6,7,8,9)
    #dim(m) <- c(3,3)
    N<-as.integer(args[1])
    if(is.na(N)){ N=1000L }
    cat('[qr]N =', N, '\n')
    m <- runif(N*N)
    dim(m) <- c(N, N)
    list(m,N)
}


run<-function(dataset){
    m<-dataset[[1]]
    N<-dataset[[2]]


    mv <- function(m, v) {
        r <- 0
        for(i in 1L:ncol(m)) {
            r <- r + m[,i]*v[[i]]        
        }
        r
    }
    
    vm <- function(v, m) {
        r <- 0
        for(i in 1L:ncol(m)) {
            r <- r + m[i,]*v[[i]]
        }
        r
    }
    
    outer <- function(v) {
        v[rep(length(v),1L,length(v)^2)]*v[rep(length(v),length(v),length(v)^2)]
    }
    
    
    myqr <- function(m) {
        #q <- diag(ncol(m))
        for(i in 1L:ncol(m)) {
            a <- (m[,i])[i:nrow(m)]
            n <- -sign(m[,i][i])*sqrt(sum(a*a))
            v <- ifelse(1:nrow(m) < i, 0,
                    ifelse(1:nrow(m) == i, m[i,i]-n, m[,i]))
            b <- sum(v*v)
            if(b == 0) next
            m <- strip(m) - 2/b * outer((vm(v,m)))
            dim(m) <- c(N,N)
            #m <- m - 2/b * (v %*% (t(v) %*% m))
            #q <- q - 2/b * ((q %*% v) %*% t(v))
            cat(i,'\n')
        }
        list(q, m)
    }
    
    myqr(m)
    #qr(m)
}

if (!exists('harness_argc')) {
    dataset <- setup(commandArgs(TRUE))
    run(dataset)
}
