# 2D Random Walk, vector version
# src: https://www.stat.auckland.ac.nz/~ihaka/downloads/Taupo-handouts.pdf
# Author: Ross Ihaka
###############################################################################


setup <- function(args='100000') {
    n<-as.integer(args[1])
    if(is.na(n)){ n <- 100000 }
    return(n)
}

run<-function(n = 100000) {
    steps = sample(c(-1,1), n -1, replace = TRUE)
    xdir = sample(c(TRUE,FALSE), n - 1, replace = TRUE)
    xpos = c(0, cumsum(ifelse(xdir, steps, 0)))
    ypos = c(0, cumsum(ifelse(xdir, 0, steps)))
    list(x = xpos, y = ypos)
}



if (!exists('harness_argc')) {
    n <- setup(commandArgs(TRUE))
    run(n)
}

