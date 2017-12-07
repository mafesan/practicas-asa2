	.data
msg:	.asciiz "Introduce numero a guardar (0 para terminar): \n"
memerr:	.asciiz "Error: No hay memoria libre. Terminando... \n"
	.text
main:
	# Paso 1: crear nodo raiz
	
	la $a0, msg
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	beqz $v0, endop
	
	# Guardo valor centinela en $s2
	move $s2, $v0
	
	# Argumentos para create
	move $a0, $s2
	move $a1, $zero
	move $a2, $zero
	
	jal tree_node_create # (val, left, right)
	
	# Guardo en $s0 la dir. al nodo raíz del arbol
	move $s0, $v0

	# Paso 2: Pedir numeros e insertarlos en el arbol hasta leer el 0
	
askint: 

	la $a0, msg
	la $v0, 4
	syscall
	li $v0, 5
	syscall
	
	beqz $v0, printres
	
	move $a0, $v0
	move $a1, $s0
	
	jal tree_insert
	
	b askint

printres:

	jal tree_print # (tree)
	b endop

memerror:
	la $a0, memerror
	li $v0, 4
	syscall
endop:
	li $v0, 10
	syscall
	
tree_node_create: # (val, left, right)
	subu $sp, $sp, 32
	sw $ra, 8($sp)
	sw $fp, 4($sp)
	addiu $fp, $sp, 16	

	# Guardo val. entrada
	sw $a0, 0($fp)
	sw $a1, 4($fp)
	sw $a2, 8($fp)
	
	# Invoco a sbrk
	li $a0, 12
	li $v0, 9
	syscall
	
	beqz $v0, memerror # Salto si no hay memoria
	
	# Guardo param. de entrada en el nuevo nodo
	
	lw $t0, 0($fp)
	sw $t0, 0($v0)
	
	lw $t1, 4($fp)
	sw $t1, 4($v0)
	
	lw $t2, 8($fp)
	sw $t2, 8($v0)
	
	# Libero marco de pila
	lw $ra, 8($sp)
	lw $fp, 4($sp)
	addiu $sp, $sp, 32
	jr $ra
	
tree_insert: # (val, root)
	subu $sp, $sp, 32
	sw $ra, 8($sp)
	sw $fp, 4($sp)
	addiu $fp, $sp, 16	

	# Guardo val. entrada
	sw $a0, 0($fp)
	sw $a1, 4($fp)
	
	move $a1, $zero
	move $a2, $zero
	
	jal tree_node_create
	
	move $t1, $v0 # Guardo en t1 la dir. del nuevo nodo
	lw $t0, 4($fp) # cargo dir. nodo raiz
	
	lw $t2, 0($fp) # cargo val
	lw $t3, 0($t0) # cargo root_val
	
	# Insertar nuevo noso recorriendo
	# subarbol izquierdo y derecho
	
	# Libero marco de pila
	lw $ra, 8($sp)
	lw $fp, 4($sp)
	addiu $sp, $sp, 32
	jr $ra

tree_print: # (tree)
	li $t2, 13
	jr $ra