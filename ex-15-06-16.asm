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
	
	
	# A partir de aquí, tengo que hacer inserts
	
askint:	la $a0, msg
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall # Leemos entero introducido
	
	beqz $v0, endprog
	b askint

endprog:	
	li $v0, 10
	syscall
		
nomemory:	la $a0, nomem
	li $v0, 4
	syscall # Imprimo mensaje de no hay memoria
	b endprog
