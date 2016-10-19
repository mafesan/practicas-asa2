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
	# Imprimir mayor
	
	bgt $s0, $s1, move1
	move $a0, $s1
	b print1
	
move1:	move $a0, $s0	

print1:		li $v0, 1 # Imprime resultado por pantalla
	syscall
	
	li $v0, 10 # End of program
	syscall
	
	#Falta comprobar instrucciones básicas y offset
	