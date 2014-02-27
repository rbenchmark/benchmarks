

setup <- function(args='revcomp-input250000.txt') {
    if(length(args) >= 1) {
        filename<-args[1]
    } else {
        filename = 'revcomp-input250000.txt'
    }
    return(filename)
}

run<-function(inputfile) {
	exchange = function (i,j,k,l) {		 
		t=complement[[substr(data[i],j,j)]];
		substr(data[i],j,j)<<-complement[[substr(data[k],l,l)]];
		substr(data[k],l,l)<<-t;
	}
	reverse = function(i,j) {
		if (i+1 >= j){
			print("Empty sequence");
			stop();
		}
		
		fLine=i+1;
		bLine=j-1;
		fChar=1;
		bChar=nchar(data[bLine]);
		while (fLine <= bLine && (fLine != bLine || fChar < bChar)) {
			exchange(fLine,fChar,bLine, bChar);
			fChar=fChar+1;
			if (fChar > nchar(data[fLine])){
				fChar=1;
				fLine=fLine+1;
			}
			bChar=bChar-1;
			if (bChar <= 0){
				bLine = bLine-1;
				bChar = nchar(data[bLine]);
			}
		}
		
	}
	
	complement=list();
	complement[c("A","C","G","T","U","M","R","W","S","Y","K","V","H","D","B","N")]=
			c("T","G","C","A","A","K","Y","W","S","R","M","B","D","H","V","N");
	complement[c("a","c","g","t","u","m","r","w","s","y","k","v","h","d","b","n")]=
			c("T","G","C","A","A","K","Y","W","S","R","M","B","D","H","V","N");
	data=readLines(inputfile);
	headers=c(1:length(data))[substr(data,1,1)==">"]
	if (is.na(headers) || ((init<-headers[1]) != 1)) {
		print("File does not start with >");
		stop();
	}
	for (i in headers[2:length(headers)]){
		reverse(init,i);
		init=i;
	}
	reverse(init, as.integer(length(data)+1));
	cat(data, sep='\n');
}

if (!exists('harness_argc', mode='numeric')) {
    in_filename = setup(commandArgs(TRUE))
    run(in_filename)
}
