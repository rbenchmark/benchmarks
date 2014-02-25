
#changed by hwang154@illinois.edu 
# 1) according to the test harness
# 2) remove global variable lookup

setup<-function(args='20000000') {
    n<-as.integer(args[1])
    if(is.na(n)){ n=20000000L }
    
    cat('[cleaning]n =', n, '\n')
    
    data <- as.double(1:n)
    force(data)
    data
}


run<-function(data) {

    z.score <- function(data, m=mean(data), stdev=sd(data)) {
        # these two lines force the promises, allowing us to fuse m and stdev
        # otherwise they are separated by the barrier (data-m), and don't fuse.
        # can we do better?
        #m
        #stdev
        (data-m) / stdev
    }
    
    outliers <- function(data, ignore) {
        use <- !ignore(data)
        z <- z.score(data, mean(data[use]), sd(data[use]))
        sum(abs(z) > 1)
    }

    #bench part
    r<-outliers(data, function(x) { is.na(x) | x==9999 })
    cat(r,'\n');
}

if (!exists('harness_argc')) {
    dataset <- setup(commandArgs(TRUE))
    run(dataset)
}