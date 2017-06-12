	.data
intro:	.asciiz "Introduce un entero:\n"
space: .asciiz " "
askrem:	.asciiz "\nIntroduce el entero que quieres borrar\n"
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
	
	la $a0, askrem
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	move $a0, $s0
	move $a1, $v0
	
	jal remove
	
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
	beqz $a0, returnp
	jal print
	
returnp:
	lw $a0, 0($fp)
	lw $a0, 0($a0)
	li $v0, 1
	syscall #imprimo numero
	la $a0, space
	li $v0, 4
	syscall

	lw $fp, 16($sp)
	lw $ra, 20($sp)
	addiu $sp, $sp, 32
	jr $ra

remove: # remove(top,val)
	move $t0, $a0
	# Recibo primer nodo de la pila
	# Ahora empiezo a recorrer desde t0
keepsearching:	
	lw $t1, 0($t0)
	lw $t3, 4($t0)
	beq $a1, $t1, equal
	lw $t0, 4($t0)
	bnez $t0, keepsearching
	b notfound
equal:
	# Este es el nodo que quiero borrar 0($t1)
	# 4($t0) tiene que apuntar a 4($t1)
	move $v0, $t1
	lw $t5, 4($t3)
	sw $t5, 4($t0)
returnremove:
	jr $ra
	
notfound:
	move $v0, $zero
	b returnremove
	
	
