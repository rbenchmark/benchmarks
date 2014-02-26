# The Computer Language Benchmarks Game
# http://shootout.alioth.debian.org/
#
# Contributed by Jason Blevins
# Adapted from the C version by Petr Prokhorenkov

# specify input parameter n 
# n = 25000000

#program fasta
#  implicit none
#


setup <- function(args='250000') {
    n<-as.integer(args[1])
    if(is.na(n)){ n <- 250000 }
    return(n)
}

run <-function(n) {
	IM = 139968
	IA = 3877
	IC = 29573
	
	LINE_LEN = 60
	LOOKUP_SIZE = 4096
	#LOOKUP_SCALE = real(LOOKUP_SIZE - 1)
	LOOKUP_SCALE = as.double(LOOKUP_SIZE - 1)
	
	#  type :: random_t
	#     integer :: state = 42
	#  end type random_t
		
	#  type :: amino_acid_t
	#     character(len=1) :: sym
	#LOOKUP_SCALE = real(LOOKUP_SIZE - 1)
		LOOKUP_SCALE = as.double(LOOKUP_SIZE - 1)
		
	#  type :: random_t
	#     integer :: state = 42
	#  end type random_t
		
	#  type :: amino_acid_t
	#     character(len=1) :: sym
	#     real :: prob
	#     real :: cprob_lookup = 0.0
	#  end type amino_acid_t
		
	#  type(amino_acid_t), dimension(15) :: amino_acid = (/ &
	#       amino_acid_t('a', 0.27, 0.0), &
	#       amino_acid_t('c', 0.12, 0.0), &
	#       amino_acid_t('g', 0.12, 0.0), &
	#       amino_acid_t('t', 0.27, 0.0), &
	#       amino_acid_t('B', 0.02, 0.0), &
	#       amino_acid_t('D', 0.02, 0.0), &
	#       amino_acid_t('H', 0.02, 0.0), &
	#       amino_acid_t('K', 0.02, 0.0), &
	#       amino_acid_t('M', 0.02, 0.0), &
	#       amino_acid_t('N', 0.02, 0.0), &
	#       amino_acid_t('R', 0.02, 0.0), &
	#       amino_acid_t('S', 0.02, 0.0), &
	#       amino_acid_t('V', 0.02, 0.0), &
	#       amino_acid_t('W', 0.02, 0.0), &
	#       amino_acid_t('Y', 0.02, 0.0)  &
	#       /)
	amino_acid = list(
			list(sym='a', prob=0.27, cprob_lookup=0.0), 
			list(sym='c', prob=0.12, cprob_lookup=0.0), 
			list(sym='g', prob=0.12, cprob_lookup=0.0), 
			list(sym='t', prob=0.27, cprob_lookup=0.0), 
			list(sym='B', prob=0.02, cprob_lookup=0.0), 
			list(sym='D', prob=0.02, cprob_lookup=0.0), 
			list(sym='H', prob=0.02, cprob_lookup=0.0), 
			list(sym='K', prob=0.02, cprob_lookup=0.0), 
			list(sym='M', prob=0.02, cprob_lookup=0.0), 
			list(sym='N', prob=0.02, cprob_lookup=0.0),
			list(sym='R', prob=0.02, cprob_lookup=0.0), 
			list(sym='S', prob=0.02, cprob_lookup=0.0), 
			list(sym='V', prob=0.02, cprob_lookup=0.0), 
			list(sym='W', prob=0.02, cprob_lookup=0.0), 
			list(sym='Y', prob=0.02, cprob_lookup=0.0))
	
	homo_sapiens = list(
			list(sym='a', prob=0.3029549426680, cprob_lookup=0.0),
			list(sym='c', prob=0.1979883004921, cprob_lookup=0.0),
			list(sym='g', prob=0.1975473066391, cprob_lookup=0.0),
			list(sym='t', prob=0.3015094502008, cprob_lookup=0.0))
	
	alu = strsplit(
			"GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTGGGAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGAGACCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAAAATACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAATCCCAGCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAACCCGGGAGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTGCACTCCAGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA","")[[1]]
	
	# Special version with result rescaled to LOOKUP_SCALE.
	random_next_lookup <- function (random) {
		#type(random_t), intent(inout) :: random
		#real :: random_next_lookup
		
		#random%state = mod(random%state*IA + IC, IM)
		random = (random*IA + IC) %% IM
		
		#return (random%state * (LOOKUP_SCALE / IM))
		list(random=random, result=random * (LOOKUP_SCALE / IM))
	}
		
	my_repeat <- function(title, n) {
		#character(len=*), intent(in) :: title
		#integer, intent(in) :: n
		#integer, parameter :: length = len(alu)
		#character(len=length+LINE_LEN) :: buffer
		#integer :: nn, pos, bytes
		
		length = length(alu)
		
		nn = n
		pos = 1
		
		#buffer(1:length) = alu
		#buffer(length+1:) = alu
		buffer = append(alu,alu)
		
		#print '(a)', title
		cat(title)
		cat("\n")
		
		while (nn > 1) {
			if (nn > LINE_LEN) {
				bytes = LINE_LEN
			} else {
				bytes = nn
			}
			
			#print '(a)', buffer(pos:pos+bytes-1)
			cat(buffer[pos:(pos+bytes-1)] ,sep='')
			cat("\n")
			
			pos = pos + bytes
			if (pos > length) {
				pos = pos - length
			}
			nn = nn - bytes
		}
	}
	#end subroutine repeat
		
	fill_lookup <- function(amino_acid) {
		#  integer, dimension(:), intent(out) :: lookup
		#  type(amino_acid_t), dimension(:), intent(inout) :: amino_acid
		#  real :: p
		#  integer :: i, j
		
		p = 0.0
		
		#do i = 1, length(amino_acid)
		for (i in 1:length(amino_acid)) {
			p = p + amino_acid[[i]]$prob
			amino_acid[[i]]$cprob_lookup = p*LOOKUP_SCALE;
		}
		#end do
		
		# Prevent rounding error.
		amino_acid[[length(amino_acid)]]$cprob_lookup = LOOKUP_SIZE - 1.0
		
		# allocate an empty vector of size LOOKUP_SIZE
		lookup = numeric(LOOKUP_SIZE)
		
		j = 1
		#do i = 1, LOOKUP_SIZE
		for (i in 1:LOOKUP_SIZE) {
			while (amino_acid[[j]]$cprob_lookup < i - 1) {
				j = j + 1
			}
			lookup[i] = j
		}
		#end do
		
		list(lookup=lookup, amino_acid=amino_acid)
	}
	#end subroutine fill_lookup
	
	randomize<-function(amino_acid, title, n, rand) {
		#type(amino_acid_t), dimension(:), intent(inout) :: amino_acid
		#character(len=*), intent(in) :: title
		#integer, intent(in) :: n
		#type(random_t), intent(inout) :: rand
		#integer, dimension(LOOKUP_SIZE) :: lookup
		#character(len=LINE_LEN) :: line_buffer
		#integer :: i, j, u
		#real :: r
		
		#fill_lookup(lookup, amino_acid)
		t = fill_lookup(amino_acid)

		lookup = t$lookup
		#cat("lookup= ");print(lookup);
		amino_acid = t$amino_acid
		#cat("amino_acid= ");print(amino_acid);		
		#print '(a)', title
		cat(title)
		cat("\n")
		
		# allocate an empty vector for line_buffer
		line_buffer = character(LINE_LEN)
		
		j = 1
		#do i = 1, n
		for (i in 1:n) {
			#r = random_next_lookup(rand)
			tmp = random_next_lookup(rand)
			rand = tmp$random
			r = tmp$result
			
			#u = lookup(int(r)+1)
			u = lookup[r+1]
			
			while (amino_acid[[u]]$cprob_lookup < r) {
				u = u + 1
			}
			
			line_buffer[j:j] = amino_acid[[u]]$sym
			
			if (j == LINE_LEN) {
				#print '(a)', line_buffer
				cat(line_buffer,file="",sep="")
				cat("\n")
				j = 1
			} else {
				j = j + 1
			}
		}
		#end do
		if (j > 1) {
			#print '(a)', line_buffer(1:j-1)
			cat(line_buffer[1:j-1],file="",sep="")
			cat("\n")
		}
		
		list(amino_acid=amino_acid, rand=rand)
	}
	#end subroutine randomize
	
		
	# start of the main program
		
	#  character(len=60) :: arg
	#  integer :: n
	#  type(random_t) :: rand
		
	# initialize with default value
	rand = 42 
		
	#  if (command_argument_count() > 0) then
	#     call get_command_argument(1, arg)
	#     read(arg, *) n
	#  else
	#     n = 512
	#  end if
		
	#  call my_repeat(">ONE Homo sapiens alu", n*2)
	my_repeat(">ONE Homo sapiens alu", n*2)	
		
	#  call randomize(amino_acid, ">TWO IUB ambiguity codes", n*3, rand)
	t = randomize(amino_acid, ">TWO IUB ambiguity codes", n*3, rand)
	amino_acid = t$amino_acid
	rand = t$rand
		
	#  call randomize(homo_sapiens, ">THREE Homo sapiens frequency", n*5, rand)
	t = randomize(homo_sapiens, ">THREE Homo sapiens frequency", n*5, rand)
	homo_sapiens = t$amino_acid
	rand = t$rand
		
	#contains
		
	#end program fasta
}

if (!exists('harness_argc')) {
    n <- setup(commandArgs(TRUE))
    run(n)
}


