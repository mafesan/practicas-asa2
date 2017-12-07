## Un programa para calcular el factorial de 10

	.data
msg:	.asciiz "El factorial de 6 es: "

	.text
main:	la $a0, msg
	li $v0, 4
	syscall
	
	li $a0, 6 # Put argument (6) in $a0
	jal fact
	
	move $a0, $v0
	li $v0, 1
	syscall
	
	li $v0, 10
	syscall
	
fact:
	subu $sp, $sp, 32	# Marco de pila de 32 bytes
	sw $ra, 20($sp)		# Guardo return address
	sw $fp, 16($sp)		# Guardo frame pointer
	addiu $fp, $sp, 28	# Muevo frame pointer
	sw $a0, 0($fp)		# Guardo argumento (n)
	
	lw $v0, 0($fp)
	bgtz $v0, fact_recur # fact(n-1)
	li $v0, 1
	b return_fact
	
fact_recur:
	lw $v1, 0($fp)	# Cargo n
	subu $v0, $v1, 1	# Calculo n - 1
	move $a0, $v0	# Muevo valor a $a0
	jal fact
	
	lw $v1, 0($fp)
	mul $v0, $v0, $v1
	
return_fact:
	lw $ra, 20($sp)
	lw $fp, 16($sp)
	addiu $sp, $sp, 32
	jr $ra
	