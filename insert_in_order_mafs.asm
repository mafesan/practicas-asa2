	.data
intro: .asciiz "Introduce un entero\n"
mayor:	.asciiz "Es mayor\n"
menor:	.asciiz "Es menor\n"
	
	.text
main:
	la $a0, intro
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall

	move $t0, $v0
	# Creamos el primer nodo
	li $a0, 8
	li $v0, 9
	syscall # Falta comprobar que hay memoria
	
	move $s0, $v0
	sw $t0, 0($s0)
	sw $zero, 4($s0)
	
	# Entramos en el bucle
askint:

	li $v0, 5
	syscall
	beqz $v0, endp
	
	move $a0, $s0
	move $a1, $v0
	
	jal iio
	
	beqz $v0, askint
	
	move $s0, $v0
	b askint
	
	
endp:
	li $v0, 10
	syscall
	
iio:
	subu $sp, $sp, 32
	sw $fp, 16($sp)
	sw $ra, 20($sp)
	addiu $fp, $sp, 24
	
	sw $a0, 0($fp) # primer nodo
	sw $a1, 4($fp) # valor
	
	# Comparo valor en el primer nodo
	lw $t0, 0($a0)
	blt $a1, $t0, esmenor
	
	# Llamo a create
	
	move $t0, $a0
	move $t1, $a1
	
	move $a0, $t1
	move $a1, $t0
	
	jal create
	
	lw $a0, 0($fp)
	lw $a1, 4($fp)
	
	lw $fp ,16($sp)
	lw $ra, 20($sp)
	addiu $sp, $sp, 32
	jr $ra
	
create:
	move $t0, $a0
	# Creamos el primer nodo
	li $a0, 8
	li $v0, 9
	syscall # Falta comprobar que hay memoria
	
	sw $t0, 0($v0)
	sw $a1, 4($v0)
	
	jr $ra
	
esmenor:
	b endp