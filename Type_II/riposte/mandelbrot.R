#adapted from https://github.com/ispc/ispc/tree/master/examples/mandelbrot

setup<-function(args='100') {
    
    maxIterations<-as.integer(args[1])
    if(is.na(maxIterations)){ 
        maxIterations <-100L
    }
    
    width <- 2048
    height <- 1536
    
    cat('[mandelbrot]width =', width, 'height =', height, 'maxIterations =', maxIterations, '\n')
    
    x0 <- -2
    x1 <- 1
    y0 <- -1
    y1 <- 1
    
    
    dx <- (x1 - x0) / width
    dy <- (y1 - y0) / height
    
    c <- (1:(width*height)) - 1
    i <- c %% width
    j <- floor(c / width)
    
    c_re <- x0 + i * dx
    c_im <- y0 + j * dy
    
    force(c_re)
    force(c_im)
    
    list(c_re, c_im, maxIterations);
}


run<-function(dataset) {
    c_re<-dataset[[1]]
    c_im<-dataset[[2]]
    maxIterations <-dataset[[3]]

    
#c_ <- complex(real=c_re, imaginary=c_im)
    
#mandel <- function(maxIterations) {
#    z_ <- c_
#    cnt <- 0
#    for(i in 1:maxIterations) {
#        z_ <- z_*z_ + c
#        cnt <- cnt + ifelse(Mod(z_) < 2, 1, 0)
#    }
#    cnt
#}
    #bench part
    z_re <- c_re
    z_im <- c_im
    cnt <- 0
    for(i in 1:maxIterations) {
        #cnt <- cnt + ifelse(z_re * z_re + z_im * z_im <= 4, 1, 0)
        cnt <- cnt + (z_re*z_re + z_im*z_im <= 4)
        z_re2 <- c_re + (z_re*z_re - z_im*z_im)
        z_im2 <- c_im + (2. * z_re * z_im)
        z_re <- z_re2
        z_im <- z_im2
    }
    cat(length(cnt),'\n');
    
}


if (!exists('harness_argc')) {
    dataset <- setup(commandArgs(TRUE))
    run(dataset)
}
