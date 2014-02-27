#! The Computer Language Benchmarks Game
#! http://shootout.alioth.debian.org/
#!
#! Original C contributed by Sebastien Loisel
#! Conversion to C++ by Jon Harrop
#! OpenMP parallelize by The Anh Tran
#! Add SSE by The Anh Tran
#! Reconversion into C by Dan Farina
#! Conversion to Fortran by Brian Taylor

# Conversion to R by Peng Wu

# directly set command line argument n here

setup <- function(args='3000') {
    n<-as.integer(args[1])
    if(is.na(n)){ n <- 3000L }
    return(n)
}

run <-function(n) {


    #! Return element (i,j) of matrix A
    eval_A <- function(i, j) {
      #real*8 :: eval_A
      #integer, intent(in) :: i, j
      #real*8 :: di, dj
      #integer :: d
    
      #di = real(i,8)
      # penguin: i-1 because R indice starts from 1 instead of 0 from original Fortran version
      di = i-1; 
    
      #dj = real(j,8)
      # penguin: j-1 because R indice starts from 1 instead of 0 from original Fortran version
      dj = j-1;
    
      #eval_A = 1.d0 / (0.5d0 * ((di + dj) * (di + dj + 1.d0)) + di + 1.d0)
      eval_A = 1.0 / (0.5 * ((di + dj) * (di + dj + 1.0)) + di + 1.0)
      eval_A
    }
    
    
    eval_A_times_u <- function(r_begin, r_end, src) {
      #integer, intent(in) :: r_begin, r_end
      #real*8, intent(in) :: src(0:)
      #real*8, intent(out) :: dest(0:)
      #real*8 sum1
      #integer :: i, j
    
      dest = numeric((r_end-r_begin+1))
    
      #do i = r_begin, r_end
      for (i in r_begin:r_end) {
        sum1 = 0.0
        #do j = 0, n - 1
        for (j in 1:n) {
          #ea <-eval_A(i, j)
          ea <- 1.0 / (0.5 * ((i + j - 2) * (i + j - 1)) + i)
          sum1 = sum1 + src[j] * ea
        }
        dest[i] = sum1
      }
      dest
    }
    
    
    eval_At_times_u <- function(r_begin, r_end, src) {
      #integer, intent(in) :: r_begin, r_end
      #real*8, intent(in) :: src(0:)
      #real*8, intent(out) :: dest(0:)
      #real*8 sum1
      #integer :: i, j
    
      dest = numeric(r_end-r_begin+1)
    
      #do i = r_begin, r_end
      for (i in r_begin:r_end) {
        sum1 = 0.0
        #do j = 0, n - 1
        for (j in 1:n) {
          ea <- eval_A(j, i);
          ea <- 1.0 / (0.5 * ((j + i - 2) * (j + i - 1)) + j)
          sum1 = sum1 + src[j] * ea
        }
        dest[i] = sum1
      }
      dest
    }
    
    
    eval_AtA_times_u <- function(r_begin, r_end, src) {
      #integer, intent(in) :: r_begin, r_end
      #real*8, intent(in) :: src(0:)
      #real*8, intent(out) :: dest(0:)
    
      tmp = eval_A_times_u(r_begin, r_end, src)
      eval_At_times_u(r_begin, r_end, tmp)
    }
    
    
    # main function starts here
    
    #integer :: n
    #real*8, allocatable :: u(:), v(:), tmp(:)
    #integer :: n2, r_begin, r_end
    #real*8 uv, vv
    #integer :: i, tid, tcount, chunk, ite
    
    #n2 = n / 2
    
    #allocate(u(0:n-1), v(0:n-1), tmp(0:n-1))
    u = numeric(n)
    v = numeric(n)
    
    uv = 0.0
    vv = 0.0
    
    for (i in 1:n) {
      u[i] = 1.0
    }
    
    r_begin = 1
    r_end = n
    
    for (i in 1:10) {
      v = eval_AtA_times_u(r_begin, r_end, u)
      u = eval_AtA_times_u(r_begin, r_end, v)
    }
    
    for (i in 1:n) {
      uv = uv + u[i] * v[i]
      vv = vv + v[i] * v[i]
    }
    
    result=sqrt(uv / vv)
    options(digits=10)
    cat(result,'\n')
}

if (!exists('harness_argc')) {
    n <- setup(commandArgs(TRUE))
    run(n)
}
