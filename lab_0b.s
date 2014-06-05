#----------------------------------------------------------------
# Program lab_0b.s - Asemblery Laboratorium IS II rok
#----------------------------------------------------------------
#
#  To compile: as -o lab_0b.o lab_0b.s
#  To link:    ld -o lab_0b lab_0b.o
#  To run:     ./lab_0b
#
#----------------------------------------------------------------

	.data
	
dummy:				# some data
	.byte	0x00

	.text
	.global _start		# entry point
	
_start:
	MOV	$1, %eax	# exit function; numer funkcji systemowej do rejestru eax, a system ją sobie wywoła przy interrupcie
	INT	$0x80		# system interrupt, okereślony numer - służy do komunikacji z systemem; nie call, bo nie musimy znać adresu, system robi to za nas.
