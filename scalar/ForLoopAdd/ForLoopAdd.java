

class ForLoopAdd {
	public static void main( String[] args ) {
	    int n = 10000000;
	    n = args.length > 0 ? Integer.parseInt( args[0] ) : 10000000;
	    long r=0;
	    int i;
	    for(i = 0; i < n; i++) { r +=i; }
	    System.out.printf("%d\n", r);
	}
}