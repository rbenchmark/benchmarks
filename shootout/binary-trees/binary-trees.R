# R version Shootout binary-trees.
# Use R list structure to represent the binary tree.
#
# The original version from Leo Osvald uses NA as terminator. 
# The current version uses 0L to improve the performance.
#
# Contributed by Haichuan Wang, Leo Osvald
###############################################################################

setup <- function(args='12') {
    n<-as.integer(args[1])
    if(is.na(n)){ n <- 12 }
    return(n)
}

run<-function(n) {

    tree <- function(item, depth) {
        if (depth == 0L)
            return(c(item, 0L, 0L))
        return(list(item,
                        tree(2L * item - 1L, depth - 1L),
                        tree(2L * item, depth - 1L)))
    }

    check <- function(tree) {
        if(tree[[2]][[1]] == 0L) tree[[1]] else tree[[1]] + check(tree[[2]]) - check(tree[[3]]);
    }

    inputdepth <- as.integer(n);
    
    min_depth <- 4L
    max_depth <- if(min_depth + 2 > n) { min_depth + 2L} else { inputdepth }
    stretch_depth <- max_depth + 1
    
    cat(sep="", "stretch tree of depth ", stretch_depth, "\t check: ",
            check(tree(0L, stretch_depth)), "\n")
    
    long_lived_tree <- tree(0L, max_depth)
    
    for (depth in seq(min_depth, max_depth, 2L)) {
        iterations <- 2^(max_depth - depth + min_depth)
        chk_sum <- 0L
        for (i in 1:iterations)
            chk_sum <- chk_sum + check(tree(i, depth)) + check(tree(-i, depth))
        cat(sep="", iterations * 2L, "\t trees of depth ", depth, "\t check ",
                chk_sum, "\n")
    }
    
    cat(sep="", "long lived tree of depth ", max_depth, "\t check: ", 
            check(long_lived_tree), "\n")

}

if (!exists('harness_argc')) {
    n <- setup(commandArgs(TRUE))
    run(n)
}
