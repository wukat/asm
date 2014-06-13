# Kasperek Wojciech
# działa częściowo, w pętli powinno wyszukiwać maks, zapamiętać go w last, później poszukiwać kolejnego maks
# z uwzględnieniem tego, że musi on być mniejszy od poprzedniego.
# niestety brakło na to czasu/wiedzy. 
# argumenty wejsciowe należy zmieniać w main

	.data
str:
	.asciz "1234"

table:					
	.long	0,0,0,0


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

	movl	$4,%edx
outer:		
	dec		%edx
	xor		%esi,%esi
	movl	%edx,%ecx # ecx as counter (loop below)
inner:		
	movl	table(,%esi,4),%eax
	movb	str(,%esi,1),%bl
	cmpl	table+4(,%esi,4),%eax
	jae		noswap
	xchgl	table+4(,%esi,4),%eax
	xchgb	str+1(,%esi,1),%bl
	movl	%eax,table(,%esi,4)
	movb 	%bl,str(,%esi,1)
noswap:		
	inc		%esi
	loop	inner
	cmpl	$1,%edx
	jnz		outer

finish:
	movl $str, %eax
	movl %ebp, %esp
	popl %ebp
	ret
