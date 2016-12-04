	.data
	.text
main: 
	# Introducir primer entero por pantalla (A)
	li $v0, 5
	syscall
	move $s0, $v0 # Mover al registro estatico s0
	# Introducir segundo entero por pantalla (B)
	li $v0, 5
	syscall
	move $s1, $v0 # Mover al registro estatico s1
	
	mulu $s2, $s0, $s1  # s2 = AxB
	
	beqz $s1, eop  # Si B es igual a 0, el programa debe terminar
	
	li $t1, 1
multip:	mulu $t2, $s0, $t1  # t2 = A x (t1+1)
	
	move $a0, $t2  # Print t2
	li $v0, 1
	syscall
	
	li $a0, 10  #  Salto de linea
	li $v0, 11
	syscall

	addi $t1, $t1, 1  # t1 = t1+1
	bge $t2, $s2, eop  # if t2 >= s2: eop
	b multip  # else, jump to mult
	
	
eop:	li $v0, 10  
	syscall