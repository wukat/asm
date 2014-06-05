#----------------------------------------------------------------
# Program lab_0c.s - Asemblery Laboratorium IS II rok
#----------------------------------------------------------------
#
#  To compile: as -o lab_0c.o lab_0c.s
#  To link:    ld -o lab_0c lab_0c.o
#  To run:     ./lab_0c
#
#----------------------------------------------------------------

#equ to taki alias
	.equ	kernel,0x80	#Linux system functions entry
	.equ	write,0x04	#write data to file function
	.equ	exit,0x01	#exit program function

#stdin, stdout, stderr 0. 1. 2 takie numery maja przypisane

	.data
	
starttxt:			#first message
	.ascii	"Start\n"	#ascii - rezerwuje obszar pamieci na ciag znaków
endtxt:				#last message
	.ascii	"Finish\n"
gurutxt:
	.ascii	"A jem assembler guru\n"	#other message

	.text
	.global _start
	
_start:
	MOVL	$write,%eax	#write first message // czyli w eax będzie numer funkcji systemu
	MOVL	$1,%ebx         #numer pliku w ktorym chcemy umiescic dane
	MOVL	$starttxt,%ecx  #przekazujemy adres pierwszego znaku w ecx
	MOVL	$10,%edx	#w edx liczba danych
	INT	$kernel

	NOP

	MOVL	$write,%eax	#write other message
	MOVL	$1,%ebx
	MOVL	$gurutxt,%ecx
	MOVL	$21,%edx
	INT	$kernel

	NOP

	MOVL	$write,%eax	#write last message
	MOVL	$1,%ebx
	MOVL	$endtxt,%ecx
	MOVL	$7,%edx
	INT	$kernel

	NOP

theend:
	MOVL	$exit,%eax	#exit program
	INT	$kernel
