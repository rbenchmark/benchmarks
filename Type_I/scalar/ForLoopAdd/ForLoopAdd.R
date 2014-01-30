# TODO: Add comment
#
# Author: Haichuan Wang(hwang154@illinois.edu)
###############################################################################


setup <- function(args='10000000') {
    n<-as.integer(args[1])
    if(is.na(n)){ n <- 10000000 }
    return(n)
}

run <-function(n=10000000) {
  r <- 0;
  for( i in 1:n) {
    r <- r + i;
  }
  print(r)
};

if (!exists('harness_argc')) {
    n <- setup(commandArgs(TRUE))
    run(n)
}