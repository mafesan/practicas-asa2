	.data
msg0:	.asciiz "Introduce nodo (0 para terminar): "
msg1:	.asciiz "Introduce valor del nodo a eliminar: "
msg2:	.asciiz "Nodo encontrado: "
msg3:	.asciiz "Nodo no encontrado\n"
memerr:	.asciiz "Ups! No hay memoria. Reinicia MIPS! Terminando..."
	.text
main:
	la $a0, msg0
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall

	beqz $v0, endop
	move $t0, $v0
	
	# Creo el primer nodo
	li $a0, 8
	li $v0, 9
	syscall
	
	beqz $v0, nomem
	
	sw $t0, 0($v0)
	sw $zero, 4($v0)
	
	move $s0, $v0 # En $s0: primer nodo de la lista
	move $s1, $s0 # En $s1: ultimo nodo de la lista
	
askloop:
	la $a0, msg0
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	beqz $v0, endask
	
	move $a0, $s1
	move $a1, $v0
	jal insert
	
	move $s1, $v0 # Actualizo valor del último
	b askloop
	
endask:
	
	la $a0, msg1
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	move $a0, $s0
	move $a1, $v0
	
	jal remove
	
	move $a0, $s0
	jal print
	
	b endop
	

insert: # insert (last, val)
	subu $sp, $sp, 32
	sw $ra, 4($sp)
	sw $fp, 8($sp)
	addiu $fp, $sp, 16
	
	sw $a0, 0($fp)
	sw $a1, 4($fp)
	
	# Creo el nodo
	li $a0, 8
	li $v0, 9
	syscall
	
	beqz $v0, nomem
	
	lw $t0, 0($fp) # ultimo nodo
	lw $t1, 4($fp) # valor a introducir
	
	sw $t1, 0($v0)
	sw $zero, 4($v0)
	sw $v0, 4($t0)
	
	lw $ra, 4($sp)
	lw $fp, 8($sp)
	addiu $sp, $sp, 32
	jr $ra
	
nomem:
	la $a0, memerr
	li $v0, 4
	syscall
	
endop:
	li $v0, 10
	syscall

remove:
	subu $sp, $sp, 32
	sw $ra, 4($sp)
	sw $fp, 8($sp)
	addiu $fp, $sp, 16
	
	move $t0, $a0
	sw $t0, 0($fp)
remloop:
	beqz $t0, notfound
	lw $t1, 0($t0)
	lw $t2, 4($t0)
	beq $t1, $a1, found
	sw $t0, 0($fp)
	lw $t0, 4($t0)
	b remloop
found:
	lw $t1, 0($fp)
	sw $t2, 4($t1)
	move $v0, $t0
	b retremove	
	
notfound:
	la $a0, msg3
	li $v0, 4
	syscall
retremove:
	lw $ra, 4($sp)
	lw $fp, 8($sp)
	addiu $sp, $sp, 32
	jr $ra
		
print:
	subu $sp, $sp, 32
	sw $ra, 4($sp)
	sw $fp, 8($sp)
	addiu $fp, $sp, 16
	
	sw $a0, 0($fp)
	move $t0, $a0
	beqz $t0, retprint
	
	lw $a0, 4($t0)
	jal print
	
	lw $t0, 0($fp)
	lw $a0, 0($t0)
	li $v0, 1
	syscall
	
	li $a0, 10
	li $v0, 11
	syscall
	
retprint:	
	lw $ra, 4($sp)
	lw $fp, 8($sp)
	addiu $sp, $sp, 32
	jr $ra
