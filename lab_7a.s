#----------------------------------------------------------------
# Program lab_7a.s - Asemblery Laboratorium IS II rok
#----------------------------------------------------------------
#
#  To compile: as -o lab_7a.o lab_7a.s
#  To link:    ld -o lab_7a lab_7a.o
#  To run:     ./lab_7a
#
#----------------------------------------------------------------

.equ	KERNEL,	0x80		# Linux system functions entry
.equ	WRITE,	0x04		# write data to file function
.equ	EXIT,	0x01		# exit program function
.equ	STDOUT,	1		# file used for output 
.equ	LAST_X,	80		# length of graph


	.data
	
line:				# line of characters used in graph
	.space		80, ' '
x:				# x coordinate
	.long		0
y:				# y coordinate
	.long		0
periods:			# number of periods
	.long		2
x_scale:			# x axis scale coefficient
	.long		LAST_X - 1
y_shift:			# shift of plotted function
	.long		25
y_scale:			# y axis scale coefficient
	.long		20
startmsg:			# starting message
	.ascii	"Plot of y=sin(x) function\n"
startlen:			# length of message
	.long		( . - startmsg )
finalmsg:			# final message
	.ascii  "End of plot\n"
finallen:			# length of message
	.long		( . - finalmsg )
newline:			# newline character
	.ascii	"sinus\n"
	

	.text
	.global _start
	
_start:
	MOVL	$WRITE,%eax	# write function
	MOVL	$STDOUT,%ebx	# file handle in EBX
	MOVL	$startmsg,%ecx	# ECX points to starting message
	MOVL	startlen,%edx	# length of message
	INT	$KERNEL
	NOP			#------------------------------
	FINIT			# FPU initialization
	MOVL	$0,x		# starting value of x
next:
	FLDPI			# PI -> ST(0)
	FLDPI			# PI -> ST(0)
	FADDP			# PI+PI -> ST(0) / ST(1)+ST(0)->ST(1) and remove ST(0) /
	FIMUL	periods		# 2PI * number of periods -> ST(0)
	FIMUL	x		# 2 * PI * x -> ST(0)
	FIDIV	x_scale		# 2 * PI * x / x_scale -> ST(0)
	FSIN			# FSIN( ST(0) ) -> ST(0)
	FIMUL	y_scale		# sin() * y_scale -> ST(0)
	FIADD	y_shift		# sin() * y_scale + y_shift -> ST(0)
	FISTP	y		# INT( ST(0) ) -> y and remove ST(0)
	NOP			#------------------------------
	MOVL	$WRITE,%eax	# write function
	MOVL	$STDOUT,%ebx	# file handle in EBX
	MOVL	$line,%ecx	# ECX points to line of characters
	SUBL    $1, y		
	MOVL	y,%edx		# bytes to be written (y value of graph)
	INT	$KERNEL
	NOP			#------------------------------
	MOVL	$WRITE,%eax	# write function
	MOVL	$STDOUT,%ebx	# file handle in EBX
	MOVL	$newline,%ecx	# ECX points to '\n' character
	MOVL	$6,%edx		# bytes to be written (1)
	INT 	$KERNEL
	NOP			#------------------------------
	INCL	x		# next x value
	CMPL	$LAST_X,x	# last x point ?
	JNZ	next		# no - jump and compute next point
	NOP			#------------------------------
	MOVL	$WRITE,%eax	# write function
	MOVL	$STDOUT,%ebx	# file handle in EBX
	MOVL	$finalmsg,%ecx	# ECX points to final message
	MOVL	finallen,%edx	# length of message
	INT	$KERNEL
	NOP			#------------------------------
	MOVL	$EXIT,%eax	# exit program function
	MOVL	$0,%ebx		# exit code
	INT	$KERNEL

