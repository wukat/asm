#----------------------------------------------------------------
# Program lab_8.s - Asemblery Laboratorium IS II rok
#----------------------------------------------------------------
#
# Tworzenie pliku wykonywalnego:
#	gcc -o lab88 lab88.s
#
#----------------------------------------------------------------

	.data
argc:
	.asciz "argc = %d\n"
args:
	.asciz "%s\n"
sep:
	.asciz "----------------------------\n"
	
	.text
	.global main

main:
	movl 4(%esp),%ecx	# argc is here

	pushl %ecx
	pushl $argc
	call printf		# display value of argc
	addl $4,%esp
	popl %ecx

	movl 8(%esp),%ebp	# use ebp as a pointer
	#addl $4, %ebp		# address of argv[0]	

next:
	pushl %ecx		# preserve counter

	pushl (%ebp)
	pushl $args
	call printf		# display value of argv[i]
	addl $8,%esp

	popl %ecx		# restore counter

	addl $4,%ebp		# address of argv[i+1]
	loop next

	pushl $sep
	call printf		# display separator
	addl $4,%esp

	movl 12(%esp), %ebp

next1:
	cmpl $0,(%ebp)		# is env[i] == NULL
	je finish		# yes

	pushl (%ebp)		# no
	pushl $args
	call printf		# displays value of env[i]
	addl $8,%esp

	addl $4,%ebp		# address of env[i+1]
	jmp next1

finish:
	pushl $0		# this is the end...
	call exit
