	.data
msg0:	.asciiz "Introduce valor para inicializar: "
msg1:	.asciiz "Introduce el valor que quieres buscar: "
msg2:	.asciiz "El valor esta en la posicion: "
msg3:	.asciiz "Valores intercambiados. Imprimiendo: \n"
msg4:	.asciiz "Valor no encontrado :( \n"
miarr:	.word 0:5
len:	.word 6
	.text
main:

	la $a0, miarr
	la $a1, len
	lw $a1, 0($a1)
	
	jal inicializar
	
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
	
	move $s1, $v0
	
	# Imprimo posicion del valor buscado
	la $a0, msg2
	li $v0, 4
	syscall
	
	move $a0, $s1
	li $v0, 1
	syscall
	
	li $a0, 10
	li $v0, 11
	syscall

	move $a0, $s1
	addiu $a1, $s1, 1
	la $a2, miarr
	
	jal intercambiar
	
	la $a0, miarr
	
	jal imprimir
	
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
	
intercambiar:
	move $t0, $a0
	move $t1, $a1
	move $t2, $a2
	
	mul $t0, $t0, 4
	mul $t1, $t1, 4
	
	add $t3, $t2, $t0
	add $t4, $t2, $t1
	
	lw $t5, 0($t3)
	lw $t6, 0($t4)
	
	sw $t6, 0($t3)
	sw $t5, 0($t4)
	
	jr $ra

imprimir:	
	subu $sp, $sp, 32
	sw $ra, 4($sp)
	sw $fp, 8($sp)
	addiu $fp, $sp, 16
	sw $a0, 0($fp)

	lw $a0, 0($a0)
	beqz $a0, retprint
	li $v0, 1
	syscall
	
	li $a0, 10
	li $v0, 11
	syscall
	
	lw $a0, 0($fp)
	add $a0, $a0, 4
	jal imprimir
	
retprint:
	lw $ra, 4($sp)
	lw $fp, 8($sp)
	addiu $sp, $sp, 32
	jr $ra
	
inicializar:
	move $t0, $a0
	move $t1, $a1
	move $t3, $zero
	subu $t4, $t1, 1
	mul $t4, $t4, 4
	
	add $t2, $t0, $t3
loopinic:
	bgt $t3, $t4, endinic
	la $a0, msg0
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	sw $v0, 0($t2)
	add $t3, $t3, 4
	add $t2, $t0, $t3
	b loopinic
endinic:
	jr $ra