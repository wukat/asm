#----------------------------------------------------------------
# Program lab_4b.s - Asemblery Laboratorium IS II rok
#----------------------------------------------------------------
#
#  To compile: as -o lab_4b.o lab_4b.s
#  To link:    ld -o lab_4b lab_4b.o
#  To run:     ./lab_4b
#
#----------------------------------------------------------------

	.equ	kernel,	0x80	# Linux system functions entry
	.equ	open,	0x05	# open file function
	.equ	close,	0x06	# close file function
	.equ	read,	0x03	# read data from file function
	.equ	write,	0x04	# write data to file function
	.equ	exit,	0x01	# exit program function
	.equ	stderr,	0x02
	.equ	stdout,	0x01
	.equ	flags,	0x00
	.equ	mode,	0x180	# attributes for file creating
	.equ	tooval,	1
	.equ	errval,	2

	.data
	
file_n:				# file name (0 terminated)
	.string	"lab_4a.s"

file_h:				# file handle
	.long		0

buffer:				# buffer for file data
	.space		16, 0

bufsize:			# size of buffer
	.long		( . - buffer )

b_read:				# size of read data
	.long		0

errmsg:				# file error message
	.ascii	"File error!\n"

errlen:
	.long		( . - errmsg )

toomsg:				# file too big error message
	.ascii	"File too big!\n"

toolen:
	.long		( . - toomsg )

cntmsg:				# another message
	.ascii	"File contains following characters:\n"

cntlen:
	.long		( . - cntmsg )

allokmsg:			# All OK message
	.ascii	"\nAll is OK - too hard to believe!\n"

alloklen:
	.long		( . - allokmsg )

	.text
	.global _start
	
_start:
	NOP
	MOVL	$open,%eax	# open function
	MOVL	$file_n,%ebx	# EBX points to file name
	MOVL	$flags,%ecx	# flags of opened file in ECX
	MOVL	$mode,%edx	# mode of opened file in EDX
	INT		$kernel

	CMP		$0,%eax
	JL		error		# if EAX<0 then something went wrong

	MOVL	%eax,file_h	# store file handle returned in EAX
	MOVL	$write,%eax	# write function
	MOVL	$stdout,%ebx	# file handle in EBX
	MOVL	$cntmsg,%ecx	# ECX points to message
	MOVL	cntlen,%edx	# bytes to be written
	INT		$kernel

petla:
	MOVL	$read,%eax	# read function
	MOVL	file_h,%ebx	# file handle in EBX
	MOVL	$buffer,%ecx	# ECX points to data buffer
	MOVL	bufsize,%edx	# bytes to be read
	INT		$kernel

	CMP		$0,%eax
	JL		error		# if EAX<0 then something went wrong

	MOVL	%eax,b_read	# store count of read bytes

	CMP		$0,%eax
	JL		error		# if EAX<0 then something went wrong

	MOVL	$write,%eax	# write function
	MOVL	$stdout,%ebx	# file handle in EBX
	MOVL	$buffer,%ecx	# offset to first character
	MOVL	b_read,%edx	# count of characters
	INT		$kernel

	MOVL	b_read,%eax
	CMPL	bufsize,%eax	# whole file was read ? # byl dolar!
	JAE		petla		# probably not

	MOVL	$close,%eax	# close function
	MOVL	file_h,%ebx	# file handle in EBX
	INT		$kernel

all_ok:
	MOVL	$write,%eax	# write function
	MOVL	$stderr,%ebx	# file handle in EBX
	MOVL	$allokmsg,%ecx	# ECX points to All OK message
	MOVL	alloklen,%edx	# bytes to be written
	INT		$kernel

	XOR		%ebx,%ebx
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
