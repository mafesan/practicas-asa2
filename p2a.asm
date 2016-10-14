	.data

	.text
main: 
	# Introducir primer entero por pantalla
	li $v0, 5
	syscall
	move $t0, $v0 # Mover al registro temporal t0
	# Introducir segundo entero por pantalla
	li $v0, 5
	syscall
	move $t1, $v0 # Mover al registro temporal t1

	add $a0, $t0, $t1 # Suma y lo deja en $a0 (registro del que lee el syscall "print integer")
	
	li $v0, 1 # Imprime resultado por pantalla
	syscall
	
	li $v0, 10 # End of program
	syscall
