
#include <stdio.h>

long gcd(long m, long n) {
    long t;
    while (n != 0){
	    t = n;
	    n = m % n;
	    m = t;
    }
    return m;
}

long lcm(long m, long n) {
    return m * n / gcd(m,n);
}

int main(int argc, char* argv[]) {
    int rep = 10000;
    if(argc >=2) {
	rep = atoi (argv[1]);
    }

    int n = 40;
    long residual[n];
    long divisor[n];
    int i;
    for(i=0; i < n; i++) {
	residual[i] = i+1;
	divisor[i] = i+2;
    }
    long a,r;
    int iter;
    for(iter = 0; iter < rep; iter++){
	a=divisor[0];
	r=residual[0];
	for(i = 1; i < n; i++){
	    while(r % divisor[i] != residual[i]) {
		r = r+a;
	    }
	    a = lcm(a, divisor[i]);
	    //printf("a=%ld\n",a);
	}
    }
    printf("%ld\n",r);
    return 0;
}
