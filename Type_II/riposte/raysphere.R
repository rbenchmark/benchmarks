
setup<-function(args='10000000') {
    n<-as.integer(args[1])
    if(is.na(n)){ n=10000000L }

    cat('[raysphere]n =', n,'\n')
    
    xc <- as.double(0:(n-1))
    yc <- as.double(0:(n-1))
    zc <- as.double(0:(n-1))
    
    list(xc,yc,zc);
}


run<-function(dataset) {
    xo <- 0
    yo <- 0
    zo <- 0
    xd <- 1
    yd <- 0
    zd <- 0

    xc<- dataset[[1]];
    yc<- dataset[[2]];
    zc<- dataset[[3]];
    
    intersect <- function() {
        rx <- xo-xc
        ry <- yo-yc
        rz <- zo-zc
        
        a <- 1
        b <- 2*(xd*rx+yd*ry+zd*rz)
        c <- rx*rx+ry*ry+rz*rz-1
        
        disc <- b*b-4*a*c
        
        m <- sqrt(disc)        
        t0 <- (-b - m)/2
        t1 <- (-b + m)/2
        
        cond <- disc > 0
        min(pmin(t0[cond], t1[cond]))
    }
    #benchpart
    r<-intersect();
    #system.time()
    cat(r,'\n');
}

if (!exists('harness_argc')) {
    dataset <- setup(commandArgs(TRUE))
    run(dataset)
}

