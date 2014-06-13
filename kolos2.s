# Kasperek Wojciech

# 	extern char * order_of(long a, long b, long c, long d);
#
# 	a,b,c,d - for longs, unordered
# 	returns string of indexes (sorted by order of a,b,c,d - descending)

	.data
str:
	.asciz "1234"						# string to return

table:					
	.long	0,0,0,0						# array for digits


	.text
	.type order_of, @function
	.globl order_of

order_of:
	pushl %ebp
	movl %esp, %ebp

	# 8(%ebp) -> a
	# 12(%ebp) -> b
	# 16(%ebp) -> c
	# 20(%ebp) -> d

	# moving parameters into array
	movl 	$0, %esi
	movl 	8(%ebp), %eax
	movl 	%eax, table(,%esi,4)
	incl	%esi
	movl 	12(%ebp), %eax
	movl 	%eax, table(,%esi,4)
	incl	%esi
	movl 	16(%ebp), %eax
	movl 	%eax, table(,%esi,4)
	incl	%esi
	movl 	20(%ebp), %eax
	movl 	%eax, table(,%esi,4)

	movl	$4,%edx						# counter of parameters
outer:									# outer loop
	dec		%edx
	xor		%esi,%esi
	movl	%edx,%ecx 					# ecx as counter of inner loop
inner:		
	movl	table(,%esi,4),%eax			# comparing elements of table
	movb	str(,%esi,1),%bl
	cmpl	table+4(,%esi,4),%eax
	jae		noswap
	xchgl	table+4(,%esi,4),%eax		# swaping if act > next
	xchgb	str+1(,%esi,1),%bl			# swaping indexes
	movl	%eax,table(,%esi,4)
	movb 	%bl,str(,%esi,1)
noswap:		
	inc		%esi
	loop	inner
	cmpl	$1,%edx
	jnz		outer

finish:
	movl $str, %eax						# returning addres of a string
	movl %ebp, %esp
	popl %ebp
	ret
