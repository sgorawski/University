        .global insert_sort
        .type insert_sort,@function
        .section .text

first	= %rdi
last	= %rsi
elem	= %r8
curr	= %r9
new	= %r10
temp	= %r11

insert_sort:
	lea	8(first),curr	# *curr = first + 1
	jmp	check_cond
outer_loop:	
	mov	temp,8(new)
	sub	$8,new		# new = curr - 1
inner_loop:	
	cmp	first,new
	jb	insert		# if (first < new) goto insert
	mov	(new),temp
	cmp	elem,temp
	jg	outer_loop	# if (elem > *new) goto outer_loop
insert:	
	mov	elem,8(new)	# *(new + 1) = elem
	add	$8,curr		# curr += 1
check_cond:	
	cmp	last,curr
	ja	break		# if (last > curr) break
	mov	(curr),elem	# elem = *curr
	lea	-8(curr),new	# new = curr - 1
	jmp	inner_loop
break:
	ret

        .size   insert_sort, . - insert_sort
