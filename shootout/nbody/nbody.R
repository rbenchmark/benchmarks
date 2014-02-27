# The Computer Language Benchmarks Game
# http://shootout.alioth.debian.org/
#
# Contributed Peng Wu, David Padua


setup <- function(args='500000') {
    n<-as.integer(args[1])
    if(is.na(n)){ n <- 500000 }
    return(n)
}

run<-function(num) {

    offsetMomentum <- function (v, mass) {
    		 s1 <- v[,1]*mass[];
    		 s2 <- v[,2]*mass[];
    		 s3 <- v[,3]*mass[];
                     c ( - sum (s1) / SOLAR_MASS,
                             - sum (s2) / SOLAR_MASS,
                             - sum (s3) / SOLAR_MASS)
                     }
    
    energyfunc <- function (x,v,mass) {
    		s1 <-mass[] * (v[,1]^2+v[,2]^2+v[,3]^2);
    		energy = 0.5 * sum(s1);
    		for (i in 1:(nb-1)){
    			s2<-(x[i,1]-x[(i+1):nb,1])^2+(x[i,2]-x[(i+1):nb,2])^2+(x[i,3]-x[(i+1):nb,3])^2;
    			distance = sqrt (s2);	
    			s3<-mass[(i+1):nb]/distance;
    			energy = energy - mass[i]*sum(s3)
    		}
    		energy
    	  }
    
    tstep = 0.01
    PI = 3.141592653589793
    SOLAR_MASS = 4 * PI * PI
    DAYS_PER_YEAR = 365.24
    body=list( sun=list    (x=0.e0,    
                            y=0.e0, 
                            z=0.e0, 
                            vx=0.e0, 
                            vy=0.e0, 
                            vz=0.e0, 
                            mass= SOLAR_MASS),
              jupiter=list( x=4.84143144246472090e0,    
                            y=-1.16032004402742839e0, 
                            z=-1.03622044471123109e-01, 
                            vx=1.66007664274403694e-03 * DAYS_PER_YEAR, 
                            vy=7.69901118419740425e-03 * DAYS_PER_YEAR, 
                            vz=-6.90460016972063023e-05 * DAYS_PER_YEAR, 
    			mass=9.54791938424326609e-04 * SOLAR_MASS),
               saturn=list( x=8.34336671824457987e+00,    
                            y=4.12479856412430479e+00, 
                            z=-4.03523417114321381e-01, 
                            vx=-2.76742510726862411e-03 * DAYS_PER_YEAR, 
                            vy=4.99852801234917238e-03 * DAYS_PER_YEAR, 
                            vz=2.30417297573763929e-05 * DAYS_PER_YEAR, 
                            mass=2.85885980666130812e-04 * SOLAR_MASS),
               uranus=list (x=1.28943695621391310e+01,    
                            y=-1.51111514016986312e+01, 
                            z=-2.23307578892655734e-01, 
                            vx=2.96460137564761618e-03 * DAYS_PER_YEAR, 
                            vy=2.37847173959480950e-03 * DAYS_PER_YEAR, 
                            vz=-2.96589568540237556e-05 * DAYS_PER_YEAR, 
                            mass=4.36624404335156298e-05 * SOLAR_MASS),
               neptune=list(x=1.53796971148509165e+01,    
                            y=-2.59193146099879641e+01, 
                            z=1.79258772950371181e-01, 
                            vx=2.68067772490389322e-03 * DAYS_PER_YEAR, 
                            vy=1.62824170038242295e-03 * DAYS_PER_YEAR, 
                            vz=-9.51592254519715870e-05 * DAYS_PER_YEAR, 
                            mass=5.15138902046611451e-05 * SOLAR_MASS)) 
              
    nb = length(body)        
    
    
    ndim = 3
    x = rep(0,nb*ndim)
    dim(x)=c(nb,ndim)
    v = rep(0,nb*ndim)
    dim(v)=c(nb,ndim)
    mass = rep(0,nb)
    i=0
    for (nam in names(body)) {
    	x[i<-i+1,] = c(body[[nam]]$x,body[[nam]]$y,body[[nam]]$z)
            v[i,] = c(body[[nam]]$vx,body[[nam]]$vy,body[[nam]]$vz)
    	mass[i] = body[[nam]]$mass
    	}
    v[1,1:3]=offsetMomentum(v, mass)
    options(digits=9)
    e=energyfunc(x,v,mass)
    cat(e,'\n');
    for (k in 1:num){
    	for (i in 1:(nb-1)){
    		dx=x[i,1]-x[(i+1):nb,1]
    		dy=x[i,2]-x[(i+1):nb,2]
    		dz=x[i,3]-x[(i+1):nb,3]
    		s1<-dx^2+dy^2+dz^2;
    		distance = sqrt (s1)
    		mag=tstep / distance ^3
    		sx<-dx*mass[(i+1):nb]*mag;
    		sy<-dy*mass[(i+1):nb]*mag;
    		sz<-dz*mass[(i+1):nb]*mag;
    		v[i,1]=v[i,1]-sum(sx)
    		v[i,2]=v[i,2]-sum(sy)
    		v[i,3]=v[i,3]-sum(sz)
    		v[(i+1):nb,1]=v[(i+1):nb,1]+dx*mass[i]*mag	
    		v[(i+1):nb,2]=v[(i+1):nb,2]+dy*mass[i]*mag
    		v[(i+1):nb,3]=v[(i+1):nb,3]+dz*mass[i]*mag		
    	}
    	x[,]=x[,]+tstep*v[,]
    }
    e=energyfunc(x,v,mass)
    cat(e,'\n');
}

if (!exists('harness_argc')) {
    n <- setup(commandArgs(TRUE))
    run(n)
}
