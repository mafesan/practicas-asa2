# Practica 5 - Treesort - Miguel Angel Fernandez Sanchez
# Sugerencia de utilización de los registros

# $s0 – Nodo raíz del árbol
# $s1 – Siguiente número introducido por el usuario
# $s2 – Valor centinela (número 0)
	.data
intro: 	.asciiz "Introduce un entero. (0 para terminar)\n"
nomem:	.asciiz "No hay memoria\n"
	.text
	
main: 
	# Paso 1: Creo nodo raíz
	# Cargo parametros root = tree_node_create ($s2, 0, 0);
	li $s2, 0 #Valor centinela
	move $a0, $s2
	li $a1, 0
	li $a2, 0
	jal tree_node_create



prints:	la $a0, intro
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	move $t0, $v0
	bne $t0, $zero, prints
	
	li $v0, 10
	syscall


# tree_node_create (val, left, right): crear un nuevo nodo con el valor indicado y

# con los punteros a los subárboles y izquierdo y derecho indicados

tree_node_create:

	# Crear pila
	subu $sp, $sp, 32	# Stack frame is 32 bytes long
	sw $ra, 20($sp)		# Save return address
	sw $fp, 16($sp)		# Save frame pointer
	addiu $fp, $sp, 28	# Set up frame pointer	
	# Invocar sbrk syscall

	# Comprobar si queda memoria

	# Liberar pila

	# Retornar

	# end tree_node_create