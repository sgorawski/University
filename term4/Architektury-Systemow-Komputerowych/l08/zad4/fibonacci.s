        .global fibonacci
        .type fibonacci,@function
        .section .text

n	= %rdi
res	= %rax
temp	= %r8

fibonacci:
	push	%rbp
	cmp	$1,n
	jbe	base_case
	dec	n
	push	n
	call	fibonacci
	pop	n
	mov	res,temp
	dec	n
	push	temp
	call	fibonacci
	pop	temp
	add	temp,res
	pop	%rbp
	ret
base_case:
	pop	%rbp
	mov	n,res
	ret

        .size   fibonacci, . - fibonacci
