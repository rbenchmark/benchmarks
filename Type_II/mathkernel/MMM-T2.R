# Matrix-Matrix Multiply
# 
###############################################################################

setup = function(args='200') {
    n <- as.integer(args[1])
    if(is.na(n)){ n <- 200 }
    
    cat("Matrix-Matrix Multiply of two",  n, "x", n, "matrices, vector method\n");
    
    A <- matrix(rnorm(n*n), ncol=n, nrow=n)
    B <- matrix(rnorm(n*n), ncol=n, nrow=n)
    
    list(A,B, n)
}



run = function(data) {
    #a and b are matrix
    A <- data[[1]]
    B <- data[[2]]
    n <- data[[3]]
    C <- matrix(n*n, ncol=n, nrow=n)
    for(i in 1:n) {
        for(j in 1:n) {
            C[i,j] = A[i,] %*% B[,j]
        }
    }
    C
}