# Wojciech Kasperek (wukat)
#
#	long reverse_tab_arg(long * tab, long n, long * even_num_count);
# 	tab - list of numbers
#	n - length of tab 
#	even_num_count - after invoking should contain number of even numbers
# 	returns average of all numbers

	.data

	.text
	.type reverse_tab_arg, @function
	.globl reverse_tab_arg

reverse_tab_arg:
	pushl 	%ebp
	movl 	%esp, %ebp
	subl 	$4, %esp   				
	movl 	$0, -4(%ebp)	# local variable for sum of all numbers
	# 8(%ebp) -> tab
	# 12(%ebp) -> n
	# 16(%ebp) -> even_num_count
	movl 	8(%ebp), %ebx	# tab in eax
	movl	12(%ebp), %ecx 	# n in ecx
	movl	16(%ebp), %edx  # even_num_count in edx
	movl	$0, (%edx)

	pushl	%ecx			
	movl	$2, %esi		# 2 in esi
sum:
	movl	-4(%ebx, %ecx, 4), %eax		# loop over array
	addl	%eax, -4(%ebp)				# sum all numbers
	pushl	%edx
	xorl	%edx, %edx					
	divl	%esi						# act number /2
	cmpl 	$0, %edx					# if act number % 2 == 0
	popl	%edx
	jne		go
	incl	(%edx)						# inc counter of even
go:
	loop	sum
	popl 	%ecx

	pushl	%ecx
	xorl 	%edx, %edx
	movl	%ecx, %eax					# size in eax
	divl	%esi						# eax / 2  -> if size was 11, it's 5
	subl	$1, %ecx					# size - 1 -> -"-, it's 10
change:
	subl	$1, %eax					# decrement counter
	movl 	(%ebx, %eax, 4), %edx		# change first with last and so on
	pushl	%ecx
	subl	%eax, %ecx
	xchgl	(%ebx, %ecx, 4), %edx
	movl	%edx, (%ebx, %eax, 4)
	popl	%ecx
	cmpl	$0, %eax
	jne		change

# average
	popl	%ecx
	xorl	%edx, %edx	
	movl	-4(%ebp), %eax				# sum to eax
	divl	%ecx						# average (result in eax)

finish:
	addl 	$4, %esp
	movl 	%ebp, %esp
	popl 	%ebp
	ret
