#----------------------------------------------------------------
# Program NFS.S - Asemblery Laboratorium IS II rok
#
#       Need for Speed - version 0.1
#
# Tworzenie pliku wynikowego:
#	gcc -o nfs nfs.s keyboard.c
#----------------------------------------------------------------
	
	.equ fun_exit,1
	.equ fun_read,3
	.equ fun_write,4
	.equ fun_sleep,162

	.equ stdin,0
	.equ stdout,1

	.equ kernel,0x80

	.equ letter_q,0x71
	.equ letter_z,0x7A
	.equ letter_x,0x78

	.equ empty, ' '
	.equ border, '|'
	.equ object, 'l'
	.equ lf,0x0A
	.equ width,11
	.equ fine,10
	.equ bonus,1

	.equ MAX_POS, 40

	.data

startpos:
	.long 10, 10, 10, 11, 12, 13, 14, 15
	.long 16, 17, 18, 19, 19, 18, 17, 16
	.long 15, 14, 13, 12, 11, 10,  9,  8
	.long  7,  6,  5,  4,  3,  2,  1,  1
	.long  1,  2,  3,  4,  5,  6,  6,  6
	.long  6,  5,  5,  4,  4,  5,  5,  6
	.long  6,  7,  6,  5,  4,  3,  2,  1
	.long  2,  3,  4,  5,  6,  7,  8,  9

str_timespec:
tv_sec:
	.long 0
tvnsec:
	.long 200000000

buf:
	.space 64,0

key:
	.long 0
line:
	.long 0
score:
	.long 0

xpos:
	.long 15

scrmsg:
	.asciz "Your score is %ld after %ld lines (or miles)\n"

#----------------------------------------------------------------

	.text
	.global main

main:
	nop
	call init_keyboard	# turn off echoing & buffering
next:
	movl $buf,%edi		# clear track
	movl $MAX_POS,%ecx
	movb $empty,%al
	rep stosb
	nop
	movl line,%ebx		# distance from start
	andl $63,%ebx		# wrap around
	movl startpos(,%ebx,4),%edi
	movb $border,buf(%edi)	# left edge of track
	nop
	cmpl xpos,%edi		# car on track?
	jb left_ok		# yes
	subl $fine,score	# no
left_ok:
	addl $width,%edi
	movb $border,buf(%edi)	# right edge of track
	cmpl xpos,%edi		# car on track?
	ja right_ok		# yes
	subl $fine,score	# no
right_ok:
	movl xpos,%esi
	movb $object,buf(%esi)	# draw a car
	movl $MAX_POS,%edi
	movb $lf,buf(%edi)	# put LF in string
	nop
	addl $bonus,score	# give a little bonus
	incl line		# move further
	nop
	call write_line		# display whole string
	nop
	call pause		# wait a minute
	nop
	call kbhit		# check a keyboard
	cmpl $0,%eax		# anything was pressed?
	jz skip			# no
	call readch		# yes - read a key
	pushl %eax		# preserve it 
empty_queue:
	call kbhit		# remove any other keys
	cmpl $0,%eax
	jz removed
	call readch
	jmp empty_queue
removed:
	popl %eax		# restore a key
	cmpl $letter_q,%eax	# quit?
	jz done			# yes
	cmpl $letter_z,%eax	# no - move left?
	jnz next_check		# no
	cmpl $0,xpos		# yes - is it possible to move left?
	jz next			# no
	decl xpos		# yes, so move left
	jmp next
next_check:
	cmpl $letter_x,%eax	# move right?
	jnz skip		# no
	cmpl $MAX_POS-1,xpos	# yes - is it possible to move right?
	jz skip			# no
	incl xpos		# yes, so move right
skip:
	jmp next		# and again...
done:
	call close_keyboard	# turn on echoing & buffering
	pushl line		# display final score...
	pushl score
	pushl $scrmsg
	call printf
	addl $12,%esp
	movl $0,%eax		# ... and quit
	ret

#----------------------------------------------------------------

	.type write_line,@function
write_line:
	movl $fun_write,%eax
	movl $stdout,%ebx
	movl $buf,%ecx
	movl $MAX_POS,%edx
	inc %edx
	int $kernel
	ret

#----------------------------------------------------------------
	
	.type pause,@function
pause:
	movl $fun_sleep,%eax
	movl $str_timespec,%ebx
	movl $0,%ecx
	int $kernel
	ret

#----------------------------------------------------------------
