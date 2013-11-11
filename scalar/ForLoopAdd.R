# TODO: Add comment
#
# Author: Haichuan
###############################################################################


run <-function(n=10000000) {
  r <- 0;
  for( i in 1:n) {
    r <- r + i;
  }
  print(r)
};

if (!exists('harness_argc')) {
#    input <- commandArgs(TRUE)
#    if(length(input) > 0) {
#        n <- as.integer(input[1])
#        run(n)
#    } else {
        run()
#    }
}