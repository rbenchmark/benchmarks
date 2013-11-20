# 2D Random Walk, optimized vector version
# src: https://www.stat.auckland.ac.nz/~ihaka/downloads/Taupo-handouts.pdf
# Author: Ross Ihaka
###############################################################################


setup <- function(args='100000') {
    n<-as.integer(args[1])
    if(is.na(n)){ n <- 100000 }
    return(n)
}

run<-function(n = 100000) {
    xsteps = c(-1, 1, 0, 0)
    ysteps = c(0, 0, -1, 1)
    dir = sample(1:4, n - 1, replace = TRUE)
    xpos = c(0, cumsum(xsteps[dir]))
    ypos = c(0, cumsum(ysteps[dir]))
    list(x = xpos, y = ypos)
}



if (!exists('harness_argc')) {
    n <- setup(commandArgs(TRUE))
    run(n)
}

