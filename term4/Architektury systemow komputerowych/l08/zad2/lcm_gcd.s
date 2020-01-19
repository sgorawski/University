        .global lcm_gcd
        .type lcm_gcd,@function
        .section .text

x	= %rdi 
y	= %rsi
x_	= %r8
y_	= %r9
lcm	= %rax
gcd	= %rdx

lcm_gcd:
	test	x,x		# edge cases
	jne	second_check	# gcd(0, x) = x
	mov	$0,lcm		# lcm(0, x) = 0
	mov	y,gcd		# gcd(0, 0) = 0
	ret
second_check:
	test	y,y
	jne	base_case
	mov	$0,lcm
	mov	x,gcd
	ret
base_case:
        mov	x,lcm
	mov	x,x_
	mov	y,y_		# copy x and y
	jmp	check_cond
loop:	
	sub	x_,y_		# Euclids algorithm
check_cond:
	cmp	y_,x_
	je	break
	cmp	y_,x_
	jbe	loop
	sub	y_,x_
	jmp	check_cond
break:	
	xor	gcd,gcd		# rdx = 0 for division
	div	x_
	mul	y		# lcm = (x / x_) * y
	mov	x_,gcd		# gcd = x_
	ret

        .size   lcm_gcd, . - lcm_gcd
