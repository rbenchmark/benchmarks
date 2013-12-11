#include <stdio.h>

int gcd(int m, int n) {
    if(n==0) { return m; }
    else { return gcd(n, m % n); }
}


int main(){
    int m = 123456789;
    int n = 234736437;
    printf("%d\n", gcd(m,n));
    return 0;
}

