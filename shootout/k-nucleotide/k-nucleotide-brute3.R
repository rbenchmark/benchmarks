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
    gen_freq <- function(seq, frame) {
        frame <- frame - 1L
        ns <- nchar(seq) - frame
        n <- 0L
        cap <- 16L
        freqs <- integer(cap)
        for (i in 1:ns) {
            subseq = substr(seq, i, i + frame)
            #if (subseq %in% names(freqs))
            #    cnt <- freqs[[subseq]]
            cnt <- freqs[subseq]
            if (is.na(cnt)) {
                #else {
                cnt <- 0L
                # ensure O(N) resizing (instead of O(N^2))
                n <- n + 1L
                
                #CTK - this optimization has no (positive) effect because the expanded space does not
                #CTK   have the names we will need; it has a detrimental effect, instead (even with GNU-R)
                freqs[[cap <- if (cap < n) 2L * cap else cap]] <- 0L
            }
            freqs[[subseq]] <- cnt + 1L
        }
        return(freqs)
    }
    
    sort_seq <- function(seq, len) {
        cnt_map <- gen_freq(seq, len)
        #print(cnt_map)
        
        #CTK needed these changes to make the benchmark work in GNU-R
        #CTK attrs <- attributes(cnt_map)
        #CTK fs <- unlist(attrs, use.names=FALSE)
        #CTK seqs <- toupper(paste(names(attrs)))
        
        #CTK --- added lines starting from here
        fs <- cnt_map[cnt_map > 0]
        seqs <- toupper(paste(names(fs)))
        #CTK --- end of added lines
        
        inds <- order(-fs, seqs)
        #cat(paste(seqs[inds], fs[inds], collapse="\n"), "\n")
#    cat(paste.(seqs[inds], 100 * fs[inds] / sum(fs), collapse="\n", digits=3),
        cat(paste(seqs[inds], 100 * fs[inds] / sum(fs), collapse="\n"),
                "\n")
    }
    
    find_seq <- function(seq, s) {
        cnt_map <- gen_freq(seq, nchar(s))
        
#CTK    if (!is.null(cnt <- attr(cnt_map, s)))
        if (!is.na(cnt <- cnt_map[s]))
            return(cnt)
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
    
    #main function
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
    seq <- paste(str_buf, collapse="")
    
    for (frame in 1:2)
        sort_seq(seq, frame)
    for (s in c("GGT", "GGTA", "GGTATT", "GGTATTTTAATT", "GGTATTTTAATTTATAGT"))
        cat(find_seq(seq, tolower(s)), sep="\t", s, "\n")
    
}

if (!exists('harness_argc', mode='numeric')) {
    in_filename = setup(commandArgs(TRUE))
    run(in_filename)
}