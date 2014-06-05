#----------------------------------------------------------------
# Funkcja do programu lab_6a - Asemblery Laboratorium IS II rok
#----------------------------------------------------------------

	.text
	.type facta, @function
	.globl facta	

facta:	pushl %ebp
	movl %esp, %ebp

	#subl $4, %esp

	movl 8(%ebp), %eax
	cmpl $1, %eax
	jbe f_1

	#movl %eax, -4(%ebp)
	dec %eax

	pushl %eax
	call facta
	addl $4, %esp

	mull 8(%ebp) #-4(%ebp)
	jmp f_e

f_1:	movl $1, %eax

f_e:	movl %ebp, %esp
	popl %ebp
	ret

#wibthout local variable
