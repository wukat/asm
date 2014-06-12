#long digits_count(char *buf, long *digits, long *max_digit)
#
#Dostaje wskaźnik do łanucha znaków, 
#funkcja ma zwrócić liczbę cyfr jaka się wsród tych znaków pojawiła(zapisać to w digits - 
#ile było jedynek, ile dwójek itd.), a w max_digit( cyfra, która wystąpiła najczęściej)
	.data
count_most_often:
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

	movl 	12(%ebp), %ecx # ecx - beginning of table

	movl 	16(%ebp), %edx # most often digit
	movl 	$-1,(%edx) 

	movl 	8(%ebp), %esi  #beginning of the string

	xorl 	%ebx, %ebx #index
	xorl 	%eax, %eax
	jmp 	check

before:
	popl 	%eax
check:
	pushl	%eax
	movb 	(%esi,%ebx,1), %al #current sign in eax
	incl	%ebx
	testb	%al, %al # test if end !!
	jz 		finish
	cmpb	$'0', %al
	jb		before
	cmpb	$'9', %al
	jg		before
	subb	$'0', %al
	addl	$1, (%ecx,%eax,4)
	pushl	%ebx
	movl 	count_most_often, %ebx 
	cmpl	(%ecx,%eax,4), %ebx	#comparing counts
	jg		go
	movl	(%ecx,%eax,4), %ebx
	movl	%ebx, count_most_often # actualize max
	movl	%eax, (%edx)	#change most often digit
go:
	popl	%ebx
	popl	%eax
	incl	%eax
	jmp 	check
	
finish:
	popl 	%eax
	movl 	%ebp, %esp
	popl 	%ebp
	ret
