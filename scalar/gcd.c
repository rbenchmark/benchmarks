
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char* argv[]) {
    int l = 100000;
    if(argc >=2) {
	l = atoi (argv[1]);
    }

    int a[l],b[l],i;
    for(i=0; i<l; i++) {
	a[i] = rand() % 1000000000 + 1;
	b[i] = rand() % 1000000000 + 1;
    }

    int m,n,t;
    for(i=0; i<l; i++) {
	m = a[i];
	n = b[i];
	while(n!=0) {
	    t = m;
	    m = n;
	    n = t % n;
	}
    }
    return 0;
}

