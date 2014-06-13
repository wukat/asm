# Wojciech Kasperek (wukat)
#
#	long histo_sum(long *h, long n, long *hs, long normalize);
# 	h - list of numbers
#	n - length of h
#	hs - list of result numbers (hs(i) = sum_j=0,j<=i_h(j)) 
#	normalize - flag if hs should be normalized (biggest - 1)
# 	returns sum of all numbers

	.data

	.text
	.type histo_sum, @function
	.globl histo_sum

histo_sum:
	pushl 	%ebp
	movl 	%esp, %ebp
	subl 	$4, %esp   				# local variable for sum of all numbers
	movl 	$0, -4(%ebp)
	# 8(%ebp) -> h
	# 12(%ebp) -> n
	# 16(%ebp) -> hs
	# 20(%ebp) -> normalize
	movl 	8(%ebp), %eax	# h in eax
	movl	16(%ebp), %ebx	# hs in ebx
	movl	12(%ebp), %ecx 	# loop counter

outer:								# loop over hs  (9, 8, ...,1), 0 out of loop
	movl	(%eax, %ecx, 4), %edx
	addl	%edx, -4(%ebp)			# add h(i) to sum
	movl	%ecx, %esi 				# index to esi - i
	pushl	%ecx					# ecx to stack, to remember outer loop counter
inner:	
	movl	(%eax, %ecx, 4), %edx 
	addl	%edx, (%ebx, %esi, 4) 	# sum up from (i to 1), 0 out of loop
	loop	inner

	movl	(%eax, %ecx, 4), %edx 	# 0 indexed elements
	addl	%edx, (%ebx, %esi, 4)
	popl 	%ecx					# outer counter from stack
	loop 	outer

	movl	(%eax, %ecx, 4), %edx 	# 0 indexed elements
	movl	%edx, (%ebx, %ecx, 4)
	addl 	%edx, -4(%ebp)			# add h(0) to sum

	cmpl	$1, 20(%ebp)			# check normalization
	jne		finish

	movl	12(%ebp), %ecx 			# loop counter
norm:								# normalization
	movl	(%ebx, %ecx, 4), %esi
	movl	$100, %eax				# * 100
	mull	%esi					
	divl	-4(%ebp)				# / sum of all numbers
	movl	%eax, (%ebx, %ecx, 4)
	loop 	norm 					# same for 0 index
	movl	(%ebx, %ecx, 4), %esi
	movl	$100, %eax
	mull	%esi
	divl	-4(%ebp)
	movl	%eax, (%ebx, %ecx, 4)

finish:
	movl	-4(%ebp), %eax
	addl 	$4, %esp
	movl 	%ebp, %esp
	popl 	%ebp
	ret
