# 2D Random Walk, scalar version
# src: https://www.stat.auckland.ac.nz/~ihaka/downloads/Taupo-handouts.pdf
# Author: Ross Ihaka
###############################################################################


setup <- function(args='100000') {
    n<-as.integer(args[1])
    if(is.na(n)){ n <- 100000 }
    return(n)
}

run = function(n = 100000) {
    xpos = ypos = numeric(n)
    for(i in 2:n) {
        # Decide whether we are moving horizontally or vertically.
        delta = if(runif(1) > .5) 1 else -1
        if (runif(1) > .5) {
            xpos[i] = xpos[i-1] + delta
            ypos[i] = ypos[i-1]
        }
        else {
            xpos[i] = xpos[i-1]
            ypos[i] = ypos[i-1] + delta
        }
    }
    list(x = xpos, y = ypos)
}



if (!exists('harness_argc')) {
    n <- setup(commandArgs(TRUE))
    run(n)
}

