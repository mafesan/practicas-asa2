# Practica 5 - Treesort - Miguel Angel Fernandez Sanchez
	
		
			
	.data
str: 	.asciiz "Introduce un entero. (0 para terminar)\n"
	.text
	
main: la $a0, str
prints:	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	move $t0, $v0
	bne $t0, $zero, prints
	
	li $v0, 10
	syscall
