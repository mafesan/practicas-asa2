	.data
str:	.asciiz "El resultado es: "
	.text
main:	# 1) Leer dos numeros del usuario
	li $v0, 5
	syscall
	move $t1, $v0
	li $v0, 5
	syscall
	move $t2, $v0
	
	# 2) Realizar la suma
	add $t3, $t1, $t2
	
	la $a0, str
	li $v0, 4
	syscall
	
	move $a0, $t3
	# Imprimir resultado
	li $v0, 1
	syscall
	
	# Salir del programa
	li $v0, 10
	syscall