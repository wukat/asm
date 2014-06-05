#----------------------------------------------------------------
# Program LAB_5.S - Asemblery Laboratorium IS II rok
#----------------------------------------------------------------
#
#  To compile: as -o lab_5.o lab_5.s
#  To link:    ld -o lab_5 lab_5.o
#  To run:     ./lab_5
#
#----------------------------------------------------------------


.equ	kernel,	0x80	# Linux system functions entry
.equ	read,	0x03	# read data from file function
.equ	write,	0x04	# write data to file function
.equ	exit,	0x01	# exit program function
.equ 	stdout, 0x01
.equ	stdin,  0x00
.equ	stderr, 0x02

.equ	tooval,	-1
.equ	errval,	-2
 
	.data
	
buffer:			# buffer for file data
	.space		1024, 0
bufsize:		# size of buffer
	.long		( . - buffer )
b_read:			# size of read data
	.long		0
errmsg:			# file error message
	.ascii		"File error!\n"
errlen:
	.long		( . - errmsg )
toomsg:			# file too big error message
	.ascii		"File too big!\n"
toolen:
	.long		( . - toomsg ) 
promptmsg:
	.ascii		"String: "
promptlen:
	.long		( . - promptmsg ) 
befmsg:
	.ascii		"Before:\n"
beflen:
	.long		( . - befmsg ) 
aftmsg:
	.ascii		"After:\n"
aftflen:
	.long		( . - aftmsg ) 
wasSpace:
	.byte       0

	.text
	.global _start
	
_start:
	NOP

	MOVL	$write,%eax	# write function
	MOVL	$stdout,%ebx	# file handle in EBX
	MOVL	$promptmsg,%ecx	# ECX points to message
	MOVL	promptlen,%edx	# bytes to be written
	INT		$kernel
	
	MOVL	$read,%eax	# read function
	MOVL	$stdin,%ebx	# file handle in EBX
	MOVL	$buffer,%ecx	# ECX points to data buffer
	MOVL	bufsize,%edx	# bytes to be read
	INT		$kernel

	CMP		$0,%eax
	JL		error		# if EAX<0 then something went wrong

	MOVL	%eax,b_read	# store count of read bytes

	CMPL	bufsize,%eax	# whole file was read ?
	JAE		toobig		# probably not

	MOVL	$write,%eax	# write function
	MOVL	$stdout,%ebx	# file handle in EBX
	MOVL	$befmsg,%ecx	# ECX points to message
	MOVL	beflen,%edx	# bytes to be written
	INT		$kernel

	MOVL	$write,%eax	# write function
	MOVL	$stdout,%ebx	# file handle in EBX
	MOVL	$buffer,%ecx	# offset to first character
	MOVL	b_read,%edx	# count of characters
	INT		$kernel

	MOVL	$buffer,%esi
	MOVL	%esi,%edi
	MOVL	b_read,%ecx
	CLD
next:
	LODSB			# al := MEM[ esi ]; esi++
	#CMPB	$'a', %al
	#JB second
	#CMPB	$'z', %al
	#JA second
	#AND     $0xDF, %al
	#JMP skip
#second:
#	CMPB	$'A', %al
#	JB skip
#	CMPB	$'Z', %al
#	JA skip
#	OR  	$0x20, %al
	CMPB	$' ', %al
	JE      makeThingsWithSpaces
	MOVB	$0, wasSpace

	CMPB	$'A', %al
	JB 		changeDigits
	CMPB	$'z', %al
	JA 		skip
	CMPB	$'a' - 1, %al
	JA 		change
	CMPB	$'Z', %al
	JA 		skip

change:
	XOR		$0x20, %al
	JMP		skip

changeDigits:
	CMPB	$'0', %al
	JB		skip
	CMPB	$'9', %al
	JA		skip
	MOVB	$'#', %al
	JMP     skip

makeThingsWithSpaces:
	CMPB    $0, wasSpace
	MOVB    $1, wasSpace
	JE     	skip
	DECB	b_read
	LOOP	next

skip:		
	STOSB			# MEM[ edi ] := al; edi++
	LOOP 	next

	MOVL	$write,%eax	# write function
	MOVL	$stdout,%ebx	# file handle in EBX
	MOVL	$aftmsg,%ecx	# ECX points to message
	MOVL	aftflen,%edx	# bytes to be written
	INT		$kernel

	MOVL	$write,%eax	# write function
	MOVL	$stdout,%ebx	# file handle in EBX
	MOVL	$buffer,%ecx	# offset to first character
	MOVL	b_read,%edx	# count of characters
	INT		$kernel

	MOV		b_read,%ebx
	JMP		theend

toobig:
	MOVL	$write,%eax	# write function
	MOVL	$stderr,%ebx	# file handle in EBX
	MOVL	$toomsg,%ecx	# ECX points to toobig message
	MOVL	toolen,%edx	# bytes to be written
	INT		$kernel
	MOVL	$tooval,%ebx
	JMP		theend

error:
	MOVL	$write,%eax	# write function
	MOVL	$stderr,%ebx	# file handle in EBX
	MOVL	$errmsg,%ecx	# ECX points to file error message
	MOVL	errlen,%edx	# bytes to be written
	INT		$kernel
	MOVL	$errval,%ebx

theend:
	MOVL	$exit,%eax	# exit program function
	INT		$kernel
