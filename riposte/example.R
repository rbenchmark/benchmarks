


setup<-function(args='20000000') {
    n<-as.integer(args[1])
    if(is.na(n)){ n=20000000 }
    cat('[example]n =', n, '\n')
    
    data <- list(
            as.double(1:n),
            as.double(1:n)
    )
    data
}


run<-function(data) {
    bin <- function(x) { ifelse(x > 0, 1, ifelse(x < 0, -1, 0)) }
    ignore <- function(x) { is.na(x) | x == 9999 }
    
    clean <- function(data) {
        data[[2]][!ignore(data[[1]]) & bin(data[[1]]) == 1]
    }
    
    r <- mean(clean(data))
    cat(r,'\n')
}


if (!exists('harness_argc')) {
    dataset <- setup(commandArgs(TRUE))
    run(dataset)
}

