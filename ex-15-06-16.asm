# Miguel Angel Fernandez
# Ejercicio examen 15-06-2016
# Lista enlazada con insert, remove y print

	.data
msg:	.asciiz "Introduce un entero y 0 para terminar\n"
newl:	.asciiz "\n"
nomem:	.asciiz "No hay memoria\n"
	.text
main:
	la $a0, msg
	li $v0, 4
	syscall # Imprimimos mensaje de introducir entero
	
	li $v0, 5
	syscall # Leemos entero introducido
	
	move $t0, $v0
	
	# Creamos el primer nodo de la lista
	li $a0, 8
	li $v0, 9
	syscall
	beqz $v0, nomemory
	# Ahora v0 contiene direccion de memoria de primer nodo
	# Inicializo nodo inicial
	move $t1, $v0
	sw $t0, 0($t1)
	li $t2, 0
	sw $t2, 4($t1)
	
	# Actualizo valores de $s0 y $s1
	# Como es el primer nodo, s0 = s1
	move $s0, $t1
	move $s1, $t1
	# A partir de aquí, tengo que hacer inserts
	
askint:	la $a0, msg
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall # Leemos entero introducido
	
	beqz $v0, exitloop

	move $a0, $s1 # Valor del último nodo de la lista
	move $a1, $v0 # Valor del nuevo nodo (numero introducido)	
	
	jal insert
	
	move $s1, $v0 # Actualizo ultimo numero de la lista

	b askint

exitloop:	
	move $a0, $s0
	jal print
		
endprog:	
	li $v0, 10
	syscall
		
nomemory:	
	la $a0, nomem
	li $v0, 4
	syscall # Imprimo mensaje de no hay memoria
	b endprog

insert:
	# Recibo 2 parametros:
	# a0: Direccion del ultimo nodo de la lista
	# a1: Entero

	move $t0, $a0
	move $t1, $a1
	
	# Crear el nuevo nodo
	# sbrk, reservando 8 bytes
	li $a0, 8
	li $v0, 9
	syscall
	
	beqz $v0, nomemory
	
	#Inicializo valores del nuevo nodo
	sw $t1, 0($v0)
	sw $zero, 4($v0)
	
	# Cargo direccion del ultimo nodo y le hago que apunte al nuevo
	la $t2, 4($t0)
	sw $v0, 4($t2)
	
	jr $ra
	
print:	

	move $t0, $a0  # Copio valor del primer nodo

ldata:	lw $t1, 0($t0) # Saco el entero actual
	lw $t2, 4($t0) # Saco el puntero al siguiente
	
	beqz $t2, endprint
	# Imprimo el entero:
	move $a0, $t1
	li $v0, 1
	syscall
	
	move $t0, $t2
	
endprint:	
	jr $ra
	
	
