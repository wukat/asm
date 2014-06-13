# Kasperek Wojciech

#	long digits_count(char *buf, long *digits, long *max_digit)
# 	buf - string
#	digits - array of 10 longs, counts number of occurrences every digit in string
#	max_digit - stores most common digit in string
# 	returns number of occurences of all digits together

	.data
count_most_often:						# actual max counter of occurances one of digits
	.long 	0

	.text
	.type digits_count, @function
	.globl digits_count

digits_count:
	pushl 	%ebp
	movl 	%esp, %ebp

	#8(%ebp) <- buf
	#12(%ebp) <- digits
	#16(%ebp) <- max_digit

	movl 	12(%ebp), %ecx 				# ecx - digits

	movl 	16(%ebp), %edx 				# edx - most often digit
	movl 	$-1,(%edx) 

	movl 	8(%ebp), %esi  				# esi - buf

	xorl 	%ebx, %ebx 					# index to 0
	xorl 	%eax, %eax 					# eax to 0
	jmp 	check

before:
	popl 	%eax
check:
	pushl	%eax
	movb 	(%esi,%ebx,1), %al 			# current sign in al
	incl	%ebx
	testb	%al, %al 					# test if end of string
	jz 		finish
	cmpb	$'0', %al 					#check if digit
	jb		before
	cmpb	$'9', %al
	jg		before
	subb	$'0', %al 					# make number from digit
	addl	$1, (%ecx,%eax,4) 			# increment counter
	pushl	%ebx
	movl 	count_most_often, %ebx 
	cmpl	(%ecx,%eax,4), %ebx			#comparing counts
	jg		go
	movl	(%ecx,%eax,4), %ebx
	movl	%ebx, count_most_often 		# actualize max
	movl	%eax, (%edx)				#change most often digit
go:
	popl	%ebx
	popl	%eax 
	incl	%eax 						# increment couter of digits
	jmp 	check
	
finish:
	popl 	%eax 
	movl 	%ebp, %esp
	popl 	%ebp
	ret
