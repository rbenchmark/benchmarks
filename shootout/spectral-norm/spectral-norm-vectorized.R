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

setup <- function(args='500') {
    n<-as.integer(args[1])
    if(is.na(n)){ n <- 500L }
    return(n)
}


run <- function(n) {
	
	#! Return element (i,j) of matrix A
	eval_A <- function(i, j) {
	  #real*8 :: eval_A
	  #integer, intent(in) :: i, j
	  #real*8 :: di, dj
	  #integer :: d
	
	  #di = real(i,8)
	  # penguin: i-1 because R indice starts from 1 instead of 0 from original Fortran version
	  di = as.double(i-1) 
	
	  #dj = real(j,8)
	  # penguin: j-1 because R indice starts from 1 instead of 0 from original Fortran version
	  dj = as.double(j-1)
	
	  #eval_A = 1.d0 / (0.5d0 * ((di + dj) * (di + dj + 1.d0)) + di + 1.d0)
	  eval_A = 1.0 / (0.5 * ((di + dj) * (di + dj + 1.0)) + di + 1.0)
	}
	
	
	eval_A_times_u <- function(r_begin, r_end, src) {
	  #integer, intent(in) :: r_begin, r_end
	  #real*8, intent(in) :: src(0:)
	  #real*8, intent(out) :: dest(0:)
	  #real*8 sum1
	  #integer :: i, j
	
	  dest = numeric((r_end-r_begin+1))
	  tmp = numeric(n)
	  for (i in r_begin:r_end) {
	    for (j in 1:n) {
	     tmp[j] = eval_A(i,j)
	    }
	    dest[i] = sum(src[1:n]*tmp[1:n])
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
	  tmp = numeric(n)
	  for (i in r_begin:r_end) {
	    for (j in 1:n) {
	      tmp[j] = eval_A(j,i);
	    }
	    dest[i] = sum(src[1:n]*tmp[1:n])
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
	
	u = rep(1.0,n)
	
	for (i in 1:10) {
	  v = eval_AtA_times_u(1, n, u)
	  u = eval_AtA_times_u(1, n, v)
	}
	
	uv = sum(u*v)
	vv = sum(v*v)
	
	result=sqrt(uv / vv)
    options(digits=10)
    cat(result,'\n')
}

if (!exists('harness_argc')) {
    n <- setup(commandArgs(TRUE))
    run(n)
}
