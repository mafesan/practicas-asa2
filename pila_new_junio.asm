	.data
intro:	.asciiz "Introduce un entero:\n"
	
	.text
	
main:
	la $a0, intro
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	move $t0, $v0
	# Creamos la cima de la pila
	li $a0, 8
	li $v0, 9
	syscall
	
	# Ahora tenemos en s0 la dir. de memoria
	move $s0, $v0
	sw $t0, 0($s0)
	
askint:	
	li $v0, 5
	syscall
	
	beqz $v0, endint
	move $t0, $v0
	
	#Voy a llamar a push asi que preparo valores
	# push(top, val)
	move $a0, $s0
	move $a1, $t0
	
	jal push
	
	move $s0, $v0
	b askint
	
endint:
	move $a0, $s0
	jal print
	li $v0, 10
	syscall
	
	
push: #push(top, val)
 	#Creo la pila 
	subu $sp, $sp, 32
	sw $fp, 16($sp)
	sw $ra, 20($sp)
	addiu $fp, $sp, 24
	
	sw $a0, 0($fp)
	sw $a1, 4($fp)
	
	#Ahora me preparo para llamar a create
	# create(val, prev)
	move $t0, $a0 # Ahora tengo en t0 = top
	move $t1, $a1 # Ahora tengo en t1 = val
	
	move $a0, $t1
	move $a1, $t0
	
	jal create
	
	lw $fp, 16($sp)
	lw $ra, 20($sp)
	addiu $sp, $sp, 32
	jr $ra
	
create: # create(val, prev)
	move $t0, $a0
	move $t1, $a1
	li $a0, 8
	li $v0, 9
	syscall
	
	sw $t0, 0($v0)
	sw $t1, 4($v0)
	jr $ra
	
print:
	subu $sp, $sp, 32
	sw $fp, 16($sp)
	sw $ra, 20($sp)
	addiu $fp, $sp, 24
	sw $a0, 0($fp)
	# Primer nodo
	# t0 = val

	move $t1, $a0
	lw $a0, 4($t1)
	beqz $a0, endp
	jal print
	
endp:
	lw $a0, 0($fp)
	lw $a0, 0($a0)
	li $v0, 1
	syscall #imprimo numero

	lw $fp, 16($sp)
	lw $ra, 20($sp)
	addiu $sp, $sp, 32
	jr $ra
	