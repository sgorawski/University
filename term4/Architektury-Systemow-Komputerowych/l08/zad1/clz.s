        .global clz
        .type clz,@function
        .section .text


x 	= %rdi
res 	= %rax
y 	= %rbx
i 	= %rcx
i8b	= %cl

clz:
        mov     $32,i
	mov	$64,res
	jmp	check_cond
loop:	
	shr	i
check_cond:	
	test	i,i
	jle	break
	mov	x,y
	shr	i8b,y
	test	y,y
	je	loop
	mov	y,x
	sub	i,res
	jmp	loop
break:	
	sub	x,res
	ret

        .size   clz, . - clz
