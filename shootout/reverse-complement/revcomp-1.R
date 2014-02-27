# ------------------------------------------------------------------
# The Computer Language Shootout
# http://shootout.alioth.debian.org/
#
# Contributed by Leo Osvald
#
# Original Loc: https://github.com/allr/fastr/tree/master/test/r/shootout/reversecomplement
# Modified to be compatible with rbenchmark interface
# ------------------------------------------------------------------

setup <- function(args='revcomp-input250000.txt') {
    if(length(args) >= 1) {
        filename<-args[1]
    } else {
        filename = 'revcomp-input250000.txt'
    }
    return(filename)
}

run<-function(in_filename) {
    codes <- c(
            "A", "C", "G", "T", "U", "M", "R", "W", "S", "Y", "K", "V", "H", "D", "B",
            "N")
    complements <- c(
            "T", "G", "C", "A", "A", "K", "Y", "W", "S", "R", "M", "B", "D", "H", "V",
            "N")
    comp_map <- NULL
    comp_map[codes] <- complements
    comp_map[tolower(codes)] <- complements
    
    f <- file(in_filename, "r")
    while (length(s <- readLines(f, n=1, warn=FALSE))) {
        codes <- strsplit(s, split="")[[1]]
        if (codes[[1]] == '>')
            cat(s, "\n", sep="")
        else {
            cat(paste(comp_map[codes], collapse=""), "\n", sep="")
        }
    }
    close(f)


}

if (!exists('harness_argc', mode='numeric')) {
    in_filename = setup(commandArgs(TRUE))
    run(in_filename)
}
