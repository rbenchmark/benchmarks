
# pca (via eigen values of covariance matrix) + reprojection onto new basis


setup<-function(args='100000') {
    N<-as.integer(args[1])
    if(is.na(N)){ 
        N <- 100000L #according to gen pca
        #N <- 1000000L
    }
    cat('[pca]N =', N, '\n')
    D <- 50L
    
    a <- read.table("data/pca.txt")[[1]]
    dim(a) <- c(N, D)
    
    a
}


run<-function(dataset){

    cov <- function(a,b) {
        if(!all(dim(a) == dim(b))) stop("matrices must be same shape")
        
        m <- nrow(a)
        n <- ncol(a)
        z <- length(a)
        
        ma <- double(n)
        mb <- double(n)
        for(i in 1L:n) {
            j <- mean(a[,i]) 
            k <- mean(b[,i])
            ma[i] <- j  # why ma[[i]]
            mb[i] <- k  # why mb[[i]]
        }
        
        r <- double(n*n)
        for(i in 1L:n) {
            for(j in i:n) {
                k_vec = (a[,i]-ma[i])*(b[,j]-mb[j]);
                k <- sum(k_vec);
                r_i <-(i-1L)*n+j;
                r_j <-(j-1L)*n+i;
                r[r_i] <- k
                r[r_j] <- k
            }
        }
        r <- r/(m-1)
        dim(r) <- c(n,n)
        r
    }
    
    ## TODO: matrix multiplication cost dominates
    ## Could just compute the principal components
    
    #do pca 
    cm <- cov(dataset,dataset)
    #cm
    r<-length(cm) #for return simple result
    #basis <- eigen(cm, symmetric=TRUE)[[2]]
    #basis
    cat(r,'\n')
}

if (!exists('harness_argc')) {
    dataset <- setup(commandArgs(TRUE))
    run(dataset)
}

