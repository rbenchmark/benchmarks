#    The Computer Language Benchmarks Game
#    http://shootout.alioth.debian.org/

#    contributed by Isaac Gouy
#    converted to Java by Oleg Mazurov
#    converted to Python by Buck Golemon
#    modified by Justin Peel
#
#    R Comment:
#    converted to R by Haichuan


setup <- function(args='10') {
    n<-as.integer(args[1])
    if(is.na(n)){ n <- 10 }
    return(n)
}


run <- function(n) {
    maxFlipsCount <- 0;
    permSign <- TRUE;
    checksum <- 0;
    
    perm1 <- 0:(n-1);
    count <- perm1; # do copy
    rxrange <- 3:(n-1);
    nm <- n - 1;
    
    while (TRUE) {
        k <- perm1[1];
        if (k != 0) {
            perm <- perm1;
            flipsCount <- 1;
            kk <- perm[k + 1];
            while (kk != 0){
                perm[1:(k+1)] <- perm[(k+1):1];
                flipsCount <- flipsCount+1;
                k <- kk;
                kk <- perm[kk + 1];
            }
            
            if (maxFlipsCount < flipsCount) {
                maxFlipsCount <- flipsCount;
            }
            checksum <- checksum + (if(permSign) flipsCount else -flipsCount);
        }
        
        # Use incremental change to generate another permutation
        if(permSign) {
            tmp <-perm1[2]; 
            perm1[2] <- perm1[1];
            perm1[1] <- tmp;
            permSign <- FALSE;
        }
        else {
            tmp <-perm1[3];
            perm1[3] <- perm1[2];
            perm1[2] <- tmp;
            permSign <- TRUE;
            
            breaked <- FALSE;
            for (r in rxrange) {
                if (count[r] != 0 ){
                    breaked <- TRUE;
                    break;
                }
                count[r] <- r - 1
                perm0 <- perm1[1];
                perm1[1:r] <- perm1[2:(r+1)];
                perm1[r+1] <- perm0;
            }
            if(!breaked) {
                r <- nm + 1;
                if (count[r] == 0){
                    print( checksum );
                    return(maxFlipsCount);
                }
            }
            count[r] <- count[r] - 1;
        }
    }
}

if (!exists('harness_argc')) {
    n <- setup(commandArgs(TRUE))
    cat("Pfannkuchen(", n, ") = ", run(n), "\n", sep="")
}
