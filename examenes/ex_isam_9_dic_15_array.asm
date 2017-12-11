	.data
msg1:	.asciiz "Introduce el valor que quieres buscar: "
msg2:	.asciiz "El valor esta en la posicion: "
msg3:	.asciiz "Valores intercambiados. Imprimiendo: \n"
msg4:	.asciiz "Valor no encontrado :( \n"
miarr:	.word 3, 5, 6, 12, 9, 1
	.text
main:
	la $a0, msg1
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	la $a0, miarr # array
	move $a1, $v0 # valor
	move $a2, $zero # pos. desde
	li $a3, 6 # longitud
	
	jal buscarDesde
	
	beq $v0, -1, notfound
	
	move $t0, $v0
	
	# Imprimo posicion del valor buscado
	la $a0, msg2
	li $v0, 4
	syscall
	
	move $a0, $t0
	li $v0, 1
	syscall
	
	li $a0, 10
	li $v0, 11
	syscall
	
	b endop
	
notfound: 
	la $a0, msg4
	li $v0, 4
	syscall

endop:
	li $v0, 10
	syscall
	
buscarDesde:
	subu $sp, $sp, 32
	sw $ra, 4($sp)
	sw $fp, 8($sp)
	addiu $fp, $sp, 16
	
	sw $a0, 0($fp)
	sw $a1, 4($fp)
	sw $a2, 8($fp)
	sw $a3, 12($fp)
	
	bgt $a2, $a3, nf
	mul $t0, $a2, 4
	
	add $a0, $a0, $t0
	lw $t2, 0($a0)
	beq $t2, $a1, found
	# cargo valores buscarDesde(array, valor, pos+1, longitud)
	# no es necesario cargar todos, así que esto es mejorable
	lw $a0, 0($fp)
	lw $a1, 4($fp)
	lw $a2, 8($fp)
	addiu $a2, $a2, 1
	lw $a3, 12($fp)
	jal buscarDesde
	b returnBuscar
found:
	lw $v0, 8($fp)
	b returnBuscar
nf:
	li $v0, -1
returnBuscar:
	lw $ra, 4($sp)
	lw $fp, 8($sp)
	addiu $sp, $sp, 32
	jr $ra
	