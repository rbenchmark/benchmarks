# logistic regression test case

setup<-function(args=c('50000','100')) {
    N<-as.integer(args[1])
    if(is.na(N)){ 
        N <-50000L #according to gen_lr data
    }
    
    reps<-as.integer(args[2])
    if(is.na(reps)){ 
        reps <-100L
    }

    cat('[lr]N =', N, 'reps =', reps, '\n')
    
    D <- 30L
    
    p <- read.table("data/lr_p.txt")[[1]]
    cat(length(p),'\n')
    
    r <- read.table("data/lr_r.txt")[[1]]
    cat(length(r),'\n')
    
    wi <- read.table("data/lr_wi.txt")[[1]]
    
    dim(p) <- c(N,D);
    list(p, r, wi,reps);
}

run<-function(dataset) {

    D <- 30L;
    p<-dataset[[1]]
    r<-dataset[[2]]
    wi<-dataset[[3]]
    reps <- dataset[[4]]
    
    #g <- function(z) 1/(1+exp(-z))
    
    update <- function(w) {
        diff <- 1/(1+exp(p %*% w)) - r
        grad <- double(D);
        for(i in 1L:D) {
            grad[i] <- mean((p[,i]*diff))
        }
        grad
    }
    
    #benchpart
    w <- wi
    epsilon <- 0.07
    
    for(j in 1L:reps) {
        grad <- update(w)
        delta <- grad*epsilon
        w <- w - delta
    }
    
    cat(length(w),'\n');
    #glm(r~p-1, family=binomial(link="logit"), na.action=na.pass)


}

if (!exists('harness_argc')) {
    dataset <- setup(commandArgs(TRUE))
    run(dataset)
}