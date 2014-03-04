# ------------------------------------------------------------------
# The Computer Language Shootout
# http://shootout.alioth.debian.org/
#
# Contributed by Leo Osvald
# 
# Src from https://github.com/allr/fastr/tree/master/test/r/shootout/knucleotide 
# commit 8075c3a13f
# Slightly changed for rbenchmark harness
# ------------------------------------------------------------------

setup <- function(args='knucleotide-input50000.txt') {
    if(length(args) >= 1) {
        filename<-args[1]
    } else {
        filename = 'knucleotide-input50000.txt'
    }
    return(filename)
}


run <- function(in_filename) {
    #in order to make sure all files are compiled, put the four helper functions inside run()
    gen_freq <- function(seq, frame) {
        frame <- frame - 1L
        ns <- length(seq) - frame
        h <- new.env(emptyenv(), hash=TRUE)
        for (i in 1:ns) {
            subseq_str = paste(seq[i:(i + frame)], collapse="", sep="")
            if (exists(subseq_str, h, inherits=FALSE))
                cnt <- get(subseq_str, h, inherits=FALSE)
            else
                cnt <- 0L
            assign(subseq_str, cnt + 1L, h)
        }
        return(sapply(ls(h), function(k) get(k, h, inherits=FALSE)))
    }
    
    sort_seq <- function(seq, len) {
        fs <- gen_freq(seq, len)
        seqs <- names(fs)
        inds <- order(-fs, seqs)
        # cat(paste.(seqs[inds], 100 * fs[inds] / sum(fs), collapse="\n", digits=3),
        cat(paste(seqs[inds], 100 * fs[inds] / sum(fs), collapse="\n"),
                "\n")
    }
    
    find_seq <- function(seq, s) {
        freqs <- gen_freq(seq, nchar(s))
        if (s %in% names(freqs))
            return(freqs[[s]])
        return(0L)
    }
    
    paste. <- function (..., digits=16, sep=" ", collapse=NULL) {
        args <- list(...)
        if (length(args) == 0)
            if (length(collapse) == 0) character(0)
            else ""
        else {
            for(i in seq(along=args))
                if(is.numeric(args[[i]]))
                    args[[i]] <- as.character(round(args[[i]], digits))
                else args[[i]] <- as.character(args[[i]])
            .Internal(paste(args, sep, collapse))
        }
    }
    
    # the main function
    f <- file(in_filename, "r")
    while (length(line <- readLines(f, n=1, warn=FALSE))) {
        first_char <- substr(line, 1L, 1L)
        if (first_char == '>' || first_char == ';')
            if (substr(line, 2L, 3L) == 'TH')
                break
    }
    
    n <- 0L
    cap <- 8L
    str_buf <- character(cap)
    while (length(line <- scan(f, what="", nmax=1, quiet=TRUE))) {
        first_char <- substr(line, 1L, 1L)
        if (first_char == '>' || first_char == ';')
            break
        n <- n + 1L
        # ensure O(N) resizing (instead of O(N^2))
        str_buf[[cap <- if (cap < n) 2L * cap else cap]] <- ""
        str_buf[[n]] <- line
    }
    length(str_buf) <- n
    close(f)
    seq <- strsplit(paste(str_buf, collapse=""), split="")[[1]]
    
    for (frame in 1:2)
        sort_seq(seq, frame)
    for (s in c("GGT", "GGTA", "GGTATT", "GGTATTTTAATT", "GGTATTTTAATTTATAGT"))
        cat(find_seq(seq, tolower(s)), sep="\t", s, "\n")    

}

if (!exists('harness_argc', mode='numeric')) {
    in_filename = setup(commandArgs(TRUE))
    run(in_filename)
}