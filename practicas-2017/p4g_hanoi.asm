	.data
intron:	.asciiz "Introduce num. de discos: \n"
moved:	.asciiz "Muevo el disco "
fromp:	.asciiz " desde el palo "
top:	.asciiz " al palo "
	.text
main: 
	la $a0, intron
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	move $a0, $v0
	li $a1, 1
	li $a2, 2
	li $a3, 3
	
	jal hanoi
	
endop:
	li $v0, 10
	syscall

hanoi:	# hanoi(n, start, finish, extra)
	bgtz $a0, hanoi_recur
	b return_hanoi
hanoi_recur:
	# Reservo marco de pila
	subu $sp, $sp, 32
	sw $ra, 4($sp)
	sw $fp, 0($sp)
	addiu $fp, $sp, 16
	
	# Guardo en la pila argumentos de entrada
	sw $a0, 0($fp)
	sw $a1, 4($fp)
	sw $a2, 8($fp)
	sw $a3, 12($fp)
	
	# Calculo n - 1
	subu $a0, $a0, 1
	lw $a2, 12($fp)
	lw $a3, 8($fp)
	
	# Llamo a hanoi(n - 1, start, extra, finish)
	jal hanoi
	
	# Imprimo "Muevo el disco "
	la $a0, moved
	li $v0, 4
	syscall
	
	# Imprimo n
	lw $a0, 0($fp)
	li $v0, 1
	syscall
	
	# Imprimo " desde el palo "
	la $a0, fromp
	li $v0, 4
	syscall
	
	# Imprimo start
	lw $a0, 4($fp)
	li $v0, 1
	syscall
	
	# Imprimo " al palo "
	la $a0, top
	li $v0, 4
	syscall
	
	# Imprimo finish
	lw $a0, 8($fp)
	li $v0, 1
	syscall
	
	# Imprimo "\n"
	li $a0, 10
	li $v0, 11
	syscall
	
	# Llamo a hanoi(n - 1, extra, finish, start)
	lw $a0, 0($fp)
	subu $a0, $a0, 1
	
	lw $a1, 12($fp)
	lw $a2, 8($fp)
	lw $a3, 4($fp)
	jal hanoi
	
	# Libero marco de pila
	lw $ra, 4($sp)
	lw $fp, 0($sp)
	addiu $sp, $sp, 32
return_hanoi:
	jr $ra