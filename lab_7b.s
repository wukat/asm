#----------------------------------------------------------------
# Program lab_7b.s - Asemblery Laboratorium IS II rok
#----------------------------------------------------------------
#
#   to compile & link:  gcc -lm -o lab_7b lab_7b.s
#
#----------------------------------------------------------------

	.data
i:				# loop counter
	.long		1
x:				# function argument
	.double		0.0
count:
	.long 		0
sqr_a:				# function result
	.double		0.0
sqr_b:				# function result
	.double		0.0
two:				# constant
	.long		2
fmt_str:
	.asciz	"Square root of %.0lf = %.20lf\n"
fmt_str2:
	.asciz	"Number of iterations %d\n\n"

	
	.text
	.global main
	
main:
	FINIT			# FPU initialization
next:
	FILD	i		# i -> ST(0)
	FSTPL	x		# ST(0) -> x & pop from stack
				#------------------------------
	FLDL	x		# function argument -> ST(0)
	FSQRT			# sqrt( ST(0) ) -> ST(0)
	FSTPL	sqr_a		# ST(0) -> sqr_a  & pop from stack
				#------------------------------
	FLDL	sqr_a		# load & display first result
	CALL	disp
				#------------------------------
	FLDL	x		# first approximation -> ST(0)
	MOVL	$0, count
iter:	INCL    count
	FLDL	x		# function argument -> ST(0), ak in ST(1)
	FDIV	%ST(1), %ST(0)	# ST(0)/ST(1) -> ST(0)    x/ak
	FADD	%ST(1), %ST(0)	# ST(0)+ST(1) -> ST(0)    ak+x/ak
	FIDIV	two		# ST(0)/two -> ST(0)      (ak+x/ak)/2
	FCOMI	%ST(1)		# ST(1) ? ST(0)           ak ? ak+1
	FSTP	%ST(1)		# ST(0) -> ST(1) & pop from stack
	JNZ	iter		# test of convergence
	FSTPL	sqr_b		# ST(0) -> sqr_b & pop from stack
				#------------------------------

	FLDL	sqr_b		# load & display second result
	CALL	disp
	#ADDL 	$10, i

	PUSHL	count
	PUSHL	$fmt_str2
	CALL	printf
	ADDL	$8, %esp

	INCL	i		# next argument
	CMPL	$10, i	# enough ?
	JBE	next
				#------------------------------
	PUSHL	$0		# the end
	CALL	exit
	

	.type	disp, @function	# printf( fmt_str, x, ST(0) )
disp:
	SUBL 	$8, %esp	# printf needs 8 bytes for floating point number
	FSTPL 	(%esp)		# ST(0) on stack
	FLDL	x
	SUBL	$8, %esp	# printf needs 8 bytes for floating point number
	FSTPL	(%esp)		# x on stack
	PUSHL	$fmt_str	# address of fmt_str on stack
	CALL	printf
	ADDL	$20, %esp	# 8+8+4=20
	RET

