# logistic regression test case

setup<-function(args) {
    
    p <- read.table("data/lr_p.txt")[[1]]
    dim(p) <- c(length(p)/30, 30)
    r <- read.table("data/lr_r.txt")[[1]]
    
    cat('[lr_test]\n')
    
    list(p,r)
}

run<-function(dataset) {
    p<-dataset[[1]]
    r<-dataset[[2]]
    glm(r~p-1, family=binomial(link="logit"))
}

if (!exists('harness_argc')) {
    dataset <- setup(commandArgs(TRUE))
    run(dataset)
}