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

events:	
	.long	0

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
	MOVL 	$0, %esi
	MOVL 	8(%ebp), %eax
	MOVL 	%eax, table(,%esi,4)
	INCL	%esi
	MOVL 	12(%ebp), %eax
	MOVL 	%eax, table(,%esi,4)
	INCL	%esi
	MOVL 	16(%ebp), %eax
	MOVL 	%eax, table(,%esi,4)
	INCL	%esi
	MOVL 	20(%ebp), %eax
	MOVL 	%eax, table(,%esi,4)

	MOVL	$4,%edx
	MOVL	$0,events
outer:		
	DEC		%edx
	XOR		%esi,%esi
	MOV		%edx,%ecx
inner:		
	MOVL	table(,%esi,4),%eax
	MOVB	str(,%esi,1),%bl
	CMPL	table+4(,%esi,4),%eax
	JAE		noswap
	XCHGL	table+4(,%esi,4),%eax
	XCHGB	str+1(,%esi,1),%bl
	MOVL	%eax,table(,%esi,4)
	MOVB 	%bl,str(,%esi,1)
	INCL	events
noswap:		
	INC		%esi
	LOOP	inner
	CMPL	$1,%edx
	JNZ		outer

finish:
	movl $str, %eax
	movl %ebp, %esp
	popl %ebp
	ret
