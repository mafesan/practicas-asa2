	.data
msg:	.asciiz "Introduce entero (0 para terminar): "
memerr:	.asciiz "Ups! No hay memoria. Terminando... \n"	
delmsg:	.asciiz "Introduce entero a eliminar:  "
dlfail:	.asciiz "Nodo no encontrado.\n"
	.text
main:
	la $a0, msg
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	beqz $v0, endop
	move $a0, $v0
	move $a1, $zero
	jal create # create (val, prev)
	
	move $s0, $v0 # Guardo en $s0 la dir. del nodo cima

askloop:
	la $a0, msg
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	beqz $v0, printl
	move $a0, $s0
	move $a1, $v0
	
	jal push
	move $s0, $v0 # El nuevo nodo es la nueva cima
	
	b askloop
	
printl:
	move $a0, $s0
	jal print

	la $a0, delmsg
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	move $a1, $v0
	move $a0, $s0
	jal remove
	
	move $a0, $s0
	jal print
	
	b endop

errmem:
	la $a0, memerr
	li $v0, 4
	syscall
endop:
	li $v0, 10
	syscall
	
create:	# create (val, node.prev)
	move $t0, $a0
	move $t1, $a1
	
	li $a0, 8
	li $v0, 9
	syscall
	
	beqz $v0, errmem
	sw $t0, 0($v0)
	sw $t1, 4($v0)
	
	jr $ra
push:	# push (node.top, val)
	subu $sp, $sp, 32
	sw $ra, 4($sp)
	sw $fp, 8($sp)
	addiu $fp, $sp, 16

	sw $a0, 0($fp)
	sw $a1, 4($fp)
	
	lw $a0, 4($fp)
	lw $a1, 0($fp)
	
	jal create
	
	lw $ra, 4($sp)
	lw $fp, 8($sp)
	addiu $sp, $sp, 32
	jr $ra
	
print:	# print(node.top)
	subu $sp, $sp, 32
	sw $ra, 4($sp)
	sw $fp, 8($sp)
	addiu $fp, $sp, 16
	
	sw $a0, 0($fp)
	move $t0, $a0
	
	lw $t1, 4($t0)
	beqz $t1, returnp
	move $a0, $t1
	jal print
returnp:
	lw $t0, 0($fp)
	lw $a0, 0($t0)
	li $v0, 1
	syscall
	
	li $a0, 10
	li $v0, 11
	syscall
	
	lw $ra, 4($sp)
	lw $fp, 8($sp)
	addiu $sp, $sp, 32
	jr $ra
	
remove:	# remove(top, val)
 	subu $sp, $sp, 32
	sw $ra, 4($sp)
	sw $fp, 8($sp)
	addiu $fp, $sp, 16
	sw $a0, 0($fp)
	sw $a1, 4($fp)
	
	move $t0, $a0
	move $t1, $a1
	
rloop:	
	lw $t2, 0($t0)
	beq $t2, $t1, rnode
	sw $t0, 8($fp) # guardo nodo antes de cargar el siguiente
	lw $t0, 4($t0)
	beqz $t0, endol
	b rloop
	
endol:
	la $a0, dlfail
	li $v0, 4
	syscall
	b returnrem
rnode:
	move $v0, $t0
	
	lw $t5, 4($t0)
	lw $t4, 8($fp)
	sw $t5, 4($t4)
	
returnrem:
	lw $ra, 4($sp)
	lw $fp, 8($sp)
	addiu $sp, $sp, 32
	jr $ra
	
