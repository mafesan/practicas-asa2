	.data
mytext:	.space 1024
introt:	.asciiz "Introduce la cadena de caracteres: \n"
intres:	.asciiz "El entero resultante es: \n"		
	.text
	
main:	
	la $a0, introt
	li $v0, 4
	syscall
	
	la $a0, mytext
	li $a1, 1024
	li $v0, 8
	syscall
	
	move $s0, $a0
	
	move $t0, $s0
	
	li $s1, 10 # Cargo caracter \n
	# Recorro string buscando ultima posicion (\0)
	
	
	lb $t3, 0($t0) # inicializo variable num
	
nextc:	lb $t1, 0($t0)
	beq $t1, $s1, endop
	
	lb $t2, 1($t0)
	beq $t2, $s1, presult
	
	mul $t3, $t3, 10 # num = num * 10
	addi $t4, $t2, -48 # nextChar - '0'
	add $t3, $t3, $t4 # num = num + (nextChar - '0')
	
	addi $t0, $t0, 1
	
	b nextc

presult:
	la $a0, intres
	li $v0, 4
	syscall
	
	move $a0, $t3
	li $v0, 1
	syscall

endop:
	li $v0, 10
	syscall