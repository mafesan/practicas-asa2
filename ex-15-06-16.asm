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
	
	# Actualizo valores de $s0 y $s1
	# Como es el primer nodo, s0 = s1
	move $s0, $v0
	move $s1, $v0
	# Ahora v0 contiene direccion de memoria de primer nodo
	# Inicializo nodo inicial

	sw $t0, 0($v0)
	li $t2, 0
	sw $t2, 4($v0)
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
	
	move $s1, $v0 # Actualizo ultimo nodo de la lista

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
	# Primero, creamos el nodo reservando memoria
	li $a0, 8
	li $v0, 9
	syscall
	beqz $v0, nomemory
	
	# $v0 es la direccion de memoria del nuevo nodo
	# Lo inicializamos:
	sw $t1, 0($v0)
	sw $zero, 4($v0)
	
	# Ahora hacemos apuntar al ultimo nodo al nuevo
	sw $v0, 4($t0)
	
	jr $ra
	
print:	
	move $t0, $a0
chck:	
	# Ahora en t0 tengo el principio de la lista
	# Saco el entero y lo imprimo
	lw $a0, 0($t0)
	li $v0, 1
	syscall
	# Compruebo si el el ultimo nodo
	beq $t0, $s1, endp # Duda, puedo hacer esto?
	# Cargo la dirección del siguiente nodo:
	lw $t0, 4($t0)
	b chck	
	
endp:	jr $ra
