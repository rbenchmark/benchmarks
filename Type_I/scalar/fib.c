/*
 *
 */
#include <stdio.h>

int main(int argc, char* argv[]) {
    int rep;
    if(argc >=2) {
	rep = atoi (argv[1]);
    } else {
	rep = 1000;
    }

    int i, j;
    double a, b, t;
    for(i = 0; i < rep; i++) {
	a = 1;
	b = 1;
	for(j = 0; j< 1000; j++) {
	    t = a; a = b; b = b+t;
	}
    }
    printf("%f\n", b);
    return 0;
}
