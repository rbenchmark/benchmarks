
#include <stdio.h>
int main(int argc, char* argv[]) {
    int n = 10000000;
    if(argc >= 2) {
	n = atoi(argv[1]);
    }
    long r=0;
    int i;
    for(i = 0; i < n; i++) { r +=i; }
    printf("%ld\n", r);
    return 0;
}
