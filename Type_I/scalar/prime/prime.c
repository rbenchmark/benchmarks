#include <stdio.h>
#include <math.h>

int main(int argc, char* argv[]) {
    int n = 100000;
    if(argc >= 2) {
	n = atoi(argv[1]);
	if(n<2) { n = 2; }
    }

    int num_primes = 0;
    int i; double limit;
    int prime,j;
    for(i = 2; i <= n; i++) {
	limit = sqrt((double)i);
	prime = 1; //for 2 is prime
	j = 2;
	while(prime && j <= limit){
	    if((i % j) == 0) { prime = 0;}
	    j++;
	}
	if(prime) {
	    num_primes++;
	}
    }
    printf("Prime(%d)=%d\n", n, num_primes);
    return 0;
}

