# Miguel Angel Fernandez Sanchez

	.data
nomem:	.asciiz "No hay memoria\n"
newl:	.asciiz "\n"
	.text
	
main: 
	# Paso 1: Creo nodo raíz
	# Cargo parametros node_t = create (int val, node_t_next);
	
	li $a0, 3 # Numero entero aleatorio
	li $a1, 0 # node_t_next esta a null
	
	jal create
	
	move $s0, $v0 # Como solo hay un nodo, principio y final es el mismo nodo
	move $s1, $v0
	
	# Inserto un nodo
	move $a0, $s1
	li $a1, 4
	jal insert
	
	move $s1, $v0 # Actualizo valor del útlimo nodo
	
	# Inserto otro  nodo
	move $a0, $s1
	li $a1, 5
	jal insert
	
	move $s1, $v0 # Actualizo valor del útlimo nodo
	
	move $a0, $s0
	
	jal print
	
	li $v0, 10
	syscall

insert:
	# Crear pila
	subu $sp, $sp, 32	# Stack frame is 32 bytes long
	sw $ra, 20($sp)		# Save return address
	# Duda: Si no se usa fp, se guarda?
	sw $fp, 16($sp)		# Save frame pointer
	addiu $fp, $sp, 28	# Set up frame pointer	
	sw $a0, 0($fp) # Guardo parametro que me han pasado en la pila
	
	#Tengo en a0 la dir. del ultimo nodo y en a1 el nuevo valor
	move $t0, $a0
	move $t1, $a1
	
	move $a0, $t1
	li $a1, 0
	
	jal create
	
	lw $t0, 0($fp)
	sw $v0, 4($t0) # a la salida de create asigno la direccion del nodo actual 
	# que sale de $v0 al parametro 2 del nodo anterior
	
	lw $ra, 20($sp)
	lw $fp, 16($sp)
	addiu $sp, $sp, 32
	jr $ra
	
print:
	move $t0, $a0 # Me guardo a0 por si acaso
	move $t2, $a0
	# El convenio permite usar reg. estaticos desde una subrutina?
	
pnext:	lw $t1, 4($t0) # Cogo dir. memoria de next
	lw $a0, 0($t0) # Cargo entero
	li $v0, 1 # Imprimo entero
	syscall
	la $a0, newl
	li $v0, 4
	syscall
	beqz $t1, endp # Si dir. memoria es 0, fin
	move $t0, $t1
	b pnext
endp:	jr $ra	
	
	
create: 
	# Salvo valor de a0
	move $t0, $a0
	
	
	# Invocar sbrk syscall
	
	li $a0, 8 # Reservo 8 bytes
	li $v0, 9
	syscall
	
	# Falta comprobar que pasa si no hay memoria
	
	# Relleno los campos del nuevo nodo
	sw $t0, 0($v0)
	sw $a1, 4($v0)
	jr $ra
	
