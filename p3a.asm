	.data
	.text
main: 
	# Introducir primer entero por pantalla
	li $v0, 5
	syscall
	move $s0, $v0 # Mover al registro estatico s0
	# Introducir segundo entero por pantalla
	li $v0, 5
	syscall
	move $s1, $v0 # Mover al registro estatico t1

	#Comparar s0 con s1
	# Si s0 mayor imprime s0
	# Si s1 mayor, imprime s1
	
	bgt $s0, $s1, print1
	move $a0, $s1
	li $v0, 1 # Imprime resultado por pantalla
	syscall
	
	li $v0, 10 # End of program
	syscall
	
print1:	move $a0, $s0	

	li $v0, 1 # Imprime resultado por pantalla
	syscall
	
	li $v0, 10 # End of program
	syscall