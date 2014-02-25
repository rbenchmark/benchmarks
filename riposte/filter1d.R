
# tests subsetting vector and vector length changing in first iteration of the loop


setup<-function(args='10000000') {
    n<-as.integer(args[1])
    if(is.na(n)){ n=10000000L }
    cat('[filter1d]n =', n, '\n')
    a <- runif(n);
    force(a);
    a;
}

run<-function(a) {
    
filter <- function(v, f) {
    r <- 0
    for(i in 1L:length(f)) {
        r <- r + v[(1L+i): ((length(v)-length(f))+i)]*f[i]
    }
    r
}

#filter(a, c(0.1,0.15,0.2,0.3,0.2,0.15,0.1))
res<-filter(a, c(0.1,0.15,0.2,0.3,0.2,0.15,0.1));
r<-length(res);
cat(r,'\n');
}

if (!exists('harness_argc')) {
    dataset <- setup(commandArgs(TRUE))
    run(dataset)
}