# TODO: Add comment
# 
# Author: Administrator
###############################################################################


run <- function()
{
	gcd<-function(m,n) {
		if(n==0) { m; }
		else { gcd(n,m %% n); }		
	}
	m<-123456789;
	n<-234736437;
	r<-gcd(m,n);
	print(r);
}

