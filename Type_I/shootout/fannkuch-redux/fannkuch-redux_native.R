# ------------------------------------------------------------------
# The Computer Language Shootout
# http://shootout.alioth.debian.org/
#
# Contributed by Leo Osvald
#
# Original Loc: https://raw.github.com/allr/fastr/master/test/r/shootout/fannkuch/fannkuchredux-naive.r
# Modified to be compatible with rbenchmark interface
# Replace all [[]] access to [] access
# ------------------------------------------------------------------

setup <- function(args='10') {
    n<-as.integer(args[1])
    if(is.na(n)){ n <- 10 }
    return(n)
}

run <- function(n) {
    if (n > 3L)
        rxrange = 3:(n - 1)
    else
        rxrange = integer(0)
    
    max_flip_count <- 0L
    perm_sign <- TRUE
    checksum <- 0L
    perm1 <- 1:n
    count <- 0:(n - 1L)
    while (TRUE) {
        if (k <- perm1[[1L]]) {
            perm <- perm1
            flip_count <- 1L
            while ((kk <- perm[[k]]) > 1L) {
                for (lo in 1:(k %/% 2L)) {
                    hi = k - lo + 1L
                    t <- perm[[lo]]; perm[[lo]] <- perm[[hi]]; perm[[hi]] <- t
                }
                flip_count <- flip_count + 1L
                k <- kk
                kk <- perm[[kk]]
            }
            max_flip_count <- max(max_flip_count, flip_count)
            checksum <- checksum + if (perm_sign) flip_count else -flip_count
        }
        
        # Use incremental change to generate another permutation
        if (perm_sign) {
            t <- perm1[[1]]; perm1[[1]] <- perm1[[2]]; perm1[[2]] <- t
            perm_sign = FALSE
        } else {
            t <- perm1[[2]]; perm1[[2]] <- perm1[[3]]; perm1[[3]] <- t
            perm_sign = TRUE
            was_break <- FALSE
            for (r in rxrange) {
                if (count[[r]]) {
                    was_break <- TRUE
                    break
                }
                count[[r]] <- r - 1L
                perm0 <- perm1[[1L]]
                for (i in 1:r)
                    perm1[[i]] <- perm1[[i + 1L]]
                perm1[[r + 1L]] <- perm0
            }
            if (!was_break) {
                r <- n
                if (!count[[r]]) {
                    cat(checksum, "\n", sep="")
                    return(max_flip_count)
                }
            }
            count[[r]] <- count[[r]] - 1L
        }
    }
}

if (!exists('harness_argc')) {
    n <- setup(commandArgs(TRUE))
    cat("Pfannkuchen(", n, ") = ", run(n), "\n", sep="")
}
