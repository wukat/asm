	.text
	.globl crc32_a
		
crc32_a:	
	pushl %esi
	pushl %ebx
	movl 20(%esp),%ebx		# Function arg: unsigned long *crc_val
	movl 16(%esp),%ecx		# Function arg: long count
	movl 12(%esp),%esi		# Function arg: unsigned char *buf
	movl (%ebx),%eax		# crc_val in EDX
	xorl %ebx,%ebx
next:
	movzbl (%esi),%ebx		# get byte from *buf
	xorl %eax,%ebx	
	movzbl %bl,%ebx			# index to crc_tab
	sarl $8,%eax			# arithmetic shift!!!
	xorl crc_tab(,%ebx,4),%eax	# computed new crc_val
	inc  %esi			# pointer to next byte
	loop next			

	movl 20(%esp),%ebx		# pointer to crc_val
	movl %eax,(%ebx)		# crc_val updated
	popl %ebx
	popl %esi
	ret
