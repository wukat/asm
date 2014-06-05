#----------------------------------------------------------------
# Program LAB_3.S - Asemblery Laboratorium IS II rok
#----------------------------------------------------------------
#
#  To compile: as -o lab_3.o lab_3.s
#  To link:    ld -o lab_3 lab_3.o
#  To run:     ./lab_3
# ld -m elf_i386 -o lab_3 lab_3.o
# as -m32 
#
#---------------------------------------------------------------- 

	.equ	kernel,	0x80
	.equ	exit,	0x01
	.equ	stdout,	0x01
	.equ	write,	0x04
	.equ	dig0,	'0'

#----------------------------------------------------------------

	.data

table:					# table of items
	.long	10,70,50,90,60,80,40,20,0,30,100
count:					# count of items
	.long	( . - table ) >> 2  	#. biezacy badres w momencie kompilacji, w tym wypadku pierwszy bajt po tablicy
events:	
	.long	0
item:	
	.string	"Item "
line_no:	
	.string	"   "
itemval:	
	.string	" = "
number:	
	.string	"     \n"
before:	
	.string	"\nBefore:\n"
after:	
	.string	"\nAfter:\n"
dataend:

	.equ	item_len, before - item
	.equ	bef_len, after - before
	.equ	aft_len, dataend - after

#----------------------------------------------------------------

	.text
	.global _start

_start:
	NOP
	MOVL	$write,%eax
	MOVL	$stdout,%ebx
	MOVL	$before,%ecx
	MOVL	$bef_len,%edx
	INT	$kernel

	CALL	disp_table

	CALL	do_something

	MOVL	$write,%eax
	MOVL	$stdout,%ebx
	MOVL	$after,%ecx
	MOVL	$aft_len,%edx
	INT	$kernel

	CALL	disp_table

	MOVL	events,%ebx 
	MOVL	$exit,%eax
	INT	$kernel

#----------------------------------------------------------------
#
#	Function:	do_something
#	Parameters:	none
#

	.type do_something,@function

do_something:
	MOVL	count,%edx
	MOVL	$0,events
outer:		
	DEC	%edx
	XOR	%esi,%esi
	MOV	%edx,%ecx
inner:		
	MOVL	table(,%esi,4),%eax
	CMPL	table+4(,%esi,4),%eax
	JAE	noswap
	XCHGL	table+4(,%esi,4),%eax
	MOVL	%eax,table(,%esi,4)
	INCL	events
noswap:		
	INC	%esi
	LOOP	inner
	CMPL	$1,%edx
	JNZ	outer

	RET

#----------------------------------------------------------------
#
#	Function:	disp_table
#	Parameters:	none
#

	.type disp_table,@function

disp_table:
	XOR	%esi,%esi
	MOVL	count,%ecx

disp_item:		
	PUSH    %ecx
	MOVL	table(,%esi,4),%ebx
	CALL	make_string

	MOVL	$write,%eax
	MOVL	$stdout,%ebx
	MOVL	$item,%ecx
	MOVL	$item_len,%edx  #tu sie sporo pamieci wyswietli
	INT	$kernel
        POP     %ecx

	INC	%esi
	LOOP	disp_item

	RET	

#----------------------------------------------------------------
#
#	Function:	make_string
#	Parameters:	%esi - index of element
#			%ebx - value of element
#

	.type make_string,@function

make_string:
	MOVW	$0x2020, line_no
	MOV	%esi,%eax
	MOVL	$line_no + 2,%edi
	CALL	n2str

	MOVL	$0x20202020, number
	MOV	%ebx,%eax
	MOVL	$number + 4,%edi
	CALL	n2str

	RET	

#----------------------------------------------------------------
#
#	Function:	n2str
#	Parameters:	%eax - value
#			%edi - address of last character
#

	.type n2str,@function
n2str:
	PUSH	%ebx
	PUSH	%edx		#zapisuja na stosie
	MOVL	$10,%ebx	# divisor in EBX, dividend in EAX
nextdig:		
	XOR	%edx,%edx
	DIV	%ebx		# EDX:EAX div EBX// do edx reszta sie zapisze
	ADDB	$dig0,%dl	# remainder in EDX
	MOVB	%dl,(%edi)	# *(EDI) = character
	CMPL	$0,%eax		# quotient in EAX 
	JZ	empty
	DEC	%edi		# EDI--
	JMP	nextdig
empty:		
	POP	%edx 		#odtwarza ze stosu
	POP	%ebx

	RET	

#----------------------------------------------------------------
