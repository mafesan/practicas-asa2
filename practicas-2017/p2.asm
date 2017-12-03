	.data
	
	.text
main:	# 1) Leer dos numeros del usuario
	li $v0, 5
	syscall
	move $t1, $v0
	li $v0, 5
	syscall
	move $t2, $v0
	
	# 2) Realizar la suma
	add $a0, $t1, $t2
	
	# 3) Imprimir resultado
	li $v0, 1
	syscall
	
	# 4) Salir del programa
	li $v0, 10
	syscall