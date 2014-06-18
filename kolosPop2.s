# Wojciech Kasperek 

# extern char * find_character(char *s, long c, char * first_occ, char * last_occ);
# szukamy konkretnego znaku (c), funkcja zwraca liczbę wystąpień i wskaźnik na pierwsze i ostatnie wystąpienie

	.data
	.text
	.type find_character, @function
	.globl find_character

find_character:
	pushl 	%ebp
	movl 	%esp, %ebp

	subl	$8, %esp					
	movl	$0, -4(%ebp)   # zero if first time
	movl	$0, -8(%ebp)  # occ counter
	# 8(%ebp) -> string
	# 12(%ebp) -> char
	# 16(%ebp) -> first occurance
	# 20(%ebp) -> last occurance

	movl	16(%ebp), %ecx # first
	movl	20(%ebp), %ebx # last

	movl 	8(%ebp), %esi

	movl 	$0, %edx # index
check:
	movb 	(%esi,%edx,1), %al 			# current sign in al
	incl	%edx
	testb	%al, %al 					# test if end of string
	jz 		finish
	cmpb	12(%ebp), %al 				
	je		ok
	jmp 	check

ok:										# if current sign if c
	incl 	-8(%ebp)
	pushl	%esi
	addl	%edx, %esi
	subl	$1, %esi
	movl	%esi, (%ebx)
	popl 	%esi
	cmpl	$0,	-4(%ebp)
	je		first
	jmp		check

first:									# if first time
	pushl	%esi
	addl	%edx, %esi
	subl	$1, %esi
	movl	%esi, (%ecx)
	popl 	%esi
	incl	-4(%ebp)
	jmp		check


finish:
	movl	-8(%ebp), %eax				# return counter
	addl	$8, %esp
	movl 	%ebp, %esp
	popl 	%ebp
	ret
