	.data
intro1:	.asciiz "Introduce el 1er entero: \n"
intro2:	.asciiz "Introduce el 2o entero: \n"	
result:	.asciiz "El mayor es: "
	.text
main:
	# Pido primer entero
	la $a0, intro1
	li $v0, 4
	syscall
	
	#Guardo 1er entero
	li $v0, 5
	syscall
	
	move $t0, $v0
	
	# Pido 2o entero
	la $a0, intro2
	li $v0, 4
	syscall
	
	# Guardo 2o entero
	li $v0, 5
	syscall
	
	move $t1, $v0
	
	# Mensaje final
	
	la $a0, result
	li $v0, 4
	syscall
		
	bgt $t0, $t1, primmayor

	move $a0, $t1
	li $v0, 1
	syscall
	
	b endop
	
primmayor:
	move $a0, $t0
	li $v0, 1
	syscall
 	
endop:	li $v0, 10
	syscall
	