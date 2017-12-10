### lord.asm Crea una lista simplemente enlazada en la que las inserciones
### se hacen de mayor a menor valor. Por ejemplo, las inserciones de los
### nodos con valores 40, 12 y 50 tiene como resultado una lista en la que
### el primer nodo de la lista es el 50, después le sigue el 40 y 
### por último el 12 (que apunta a null).
### Después, se debe imprimir la lista de menor a mayor.
	.data
msg:	.asciiz "Introduce entero (0 para terminar): "
memerr:	.asciiz "Ups! No hay memoria. Terminando...\n"
	.text
main:
	la $a0, msg
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	beqz $v0, endop
	
	# Creo el primer nodo
	move $a0, $v0
	move $a1, $zero
	jal create
	
	move $s0, $v0  # Guardo en $s0 el primer nodo
askloop:
	la $a0, msg
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	beqz $v0, printback
	
	# Llamo a insert_in_order
	
	move $a0, $s0
	move $a1, $v0
	jal insert_in_order
	
	beqz $v0, askloop # Si devuelve 0, el primer nodo sigue siendo el mismo
	move $s0, $v0  # Actualizo valor del primer nodo
	b askloop

printback:
	move $a0, $s0
	jal print
	b endop

memoryerr:
	la $a0, memerr
	li $v0, 4
	syscall
endop:
	li $v0, 10
	syscall
	
create:
	move $t0, $a0
	move $t1, $a1
	
	li $a0, 8
	li $v0, 9
	syscall
	
	beqz $v0, memoryerr
	sw $t0, 0($v0)
	sw $t1, 4($v0)
	
	jr $ra
	
insert_in_order:
	subu $sp, $sp, 32
	sw $ra, 4($sp)
	sw $fp, 8($sp)
	addiu $fp, $sp, 16
	
	sw $a0, 0($fp) # guardo primer nodo
	sw $a1, 4($fp) # guardo valor a insertar
	
	# Creo nuevo nodo
	move $a0, $a1
	move $a1, $zero
	jal create
	
	sw $v0, 8($fp) # Guardo dir. del nuevo nodo
	
	lw $t2, 0($fp) # Cargo nodo cima
	lw $t0, 0($t2) # t0 = top.val
	lw $t1, 4($t2) # t1 = top.next
	# si el nuevo val es mayor que el top:
	lw $t3, 4($fp)
	bgt $t3, $t0, newtop # si new_val > val_top
	beqz $t1, endoflist # si es menor, y top.next es NULL, estamos al final
	sw $t2, 12($fp) # Guardo nodo actual (top)
	move $t2, $t1
	
	
searchpos:
	# en t2 tengo top.next 
	lw $t0, 0($t2)	# next.val
	lw $t1, 4($t2)	# next.next
	
	lw $t3, 4($fp) # new_val
	bgt $t3, $t0, midinsert
	beqz $t1, endoflist
	sw $t2, 12($fp) # Guardo nodo actual (top)
	move $t2, $t1
	b searchpos
	
midinsert:
	lw $t4, 8($fp) # dir. del nodo creado
	lw $t5, 12($fp) # dir del nodo anterior
	sw $t4, 4($t5) # nodo anterior.next apunta a nuevo nodo
	sw $t2, 4($t4) # new_node.next = nodo actual
	move $v0, $zero
	b retinsert

endoflist:
	# Si hemos llegado al final de la lista
	# es que el numero introducido es el mas pequeño
	lw $t0, 8($fp)
	sw $t0, 4($t2)
	move $v0, $zero
	b retinsert
	
newtop:
	lw $v0, 8($fp)
	lw $t1, 0($fp)
	sw $t1, 4($v0)

retinsert:		
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
	lw $a0, 4($a0)
	
	beqz $a0, pval
	jal print
pval:
	lw $a0, 0($fp)
	lw $a0, 0($a0)
	
	# print top.val
	li $v0, 1
	syscall
	# print \n
	li $a0, 10
	li $v0, 11
	syscall
	
retprint:
	lw $ra, 4($sp)
	lw $fp, 8($sp)
	addiu $sp, $sp, 32
	jr $ra