

setup<-function(args=c('1000000','10')){
    N<-as.integer(args[1])
    if(is.na(N)){ N=1000000L }
    
    reps<-as.integer(args[2])
    if(is.na(reps)){ reps=10L }

    cat('[kmeans]N =', N, 'reps =', reps,'\n')
    
    a <- read.table("data/kmeans.txt")[[1]]
    dim(a) <- c(N,2);
    
    means <- list(
            a[1,],
            a[2,],
            a[3,],
            a[4,],
            a[5,]
    );
#    cat(means[[1]],"\n");
#    cat(means[[2]],"\n")
#    cat(means[[3]],"\n")
#    cat(means[[4]],"\n")
#    cat(means[[5]],"\n")
#    cat("\n")
    list(a, means, reps);
    

}


run<-function(dataset) {
    a<-dataset[[1]]
    means<-dataset[[2]]
    reps<-dataset[[3]]
    K <- 5L
    # assignment step
    assignment <- function(data, means) {
        min.value <- Inf
        min.index <- 0L
        for(k in 1L:length(means)) {
            #print("loop k")
            d2 <- 0
            for(j in 1L:ncol(data)) {
                #print("loop j")
                d2 <- d2 + (data[,j]-means[[k]][j])^2
            }
            min.index <- ifelse(d2 < min.value, k, min.index)
            #print("index assign k")
            #min.index[d2 < min.value] <- k;
            #print("pimin")
            #min.index[d2 < min.value] <- k
            min.value <- pmin(d2, min.value)
        }
        min.index
    }
    
    update.means <- function(data, index) {
        means <- list()
        #idx <- factor(index-1L, 1:K)
        #for(i in 1L:ncol(data)) {
        #    means[[i]] <- lapply(split(data[,i], idx), "mean")
        #}
        for(i in 1L:ncol(data)) {
            means[[i]] <- lapply(split(data[,i], index-1L, K), "mean")
        }
        means
    }
    
    #bench part
    for(i in 1L:reps) {
        m <- update.means(a, assignment(a, means))
        # reorganize means from SoA to AoS
        for(i in 1L:K) {
            means[[i]] <- c(m[[1]][[i]], m[[2]][[i]])
        }
    }
    #cat("\n")
    cat(means[[1]],"\n")
    cat(means[[2]],"\n")
    cat(means[[3]],"\n")
    cat(means[[4]],"\n")
    cat(means[[5]],"\n")
    cat("\n")
}


#colSum <- function(data) {
#    result <- 0
#    if(nrow(data) >= ncol(data)) {
#        for(d in 1L:ncol(data)) {
#            result[d] <- sum(data[,d])
#        }
#        # or
#        #as.vector(lapply(1L:ncol(data), function(d) sum(data[,d])))
#    } else {
#        for(d in 1L:nrow(data)) {
#            result <- result + data[d,]
#        }
#    }
#    result
#}

#update.means <- function(data, index) {
#    for(k in 1L:K) {
#        means[[k]] <- colSum(data[k==index,])
#    }
    # or
    #lapply((1L:K), function(k) colSum(data[k==index,]))
#}

## handle nested lapplys
##    lapply handles reductions where computation is perpindicular to result
##    => result is short compared to computation
##    => could unroll
##    => how to distinguish from dynamic lapply?
##    => for loop implies loop carried dependencies
##        lapply doesn't

#kmeans <- function(data, means) {
#    for(i in 1:100) {
#        means <- update.means(data, assignment(data, means))
#    }
#    means
#}

#kmeans(a, means)


if (!exists('harness_argc')) {
    dataset <- setup(commandArgs(TRUE))
    run(dataset)
}