	.data
intro1:	.asciiz "Introduce el entero A: \n"
intro2:	.asciiz "Introduce el entero B: \n"		
result: .asciiz "Multiplos de A hasta AxB: \n"
bcero:	.asciiz "El entero b es 0. Terminando programa..."
	.text
main:
	# \n en ASCII es 10
	# Pido primer entero
	la $a0, intro1
	li $v0, 4
	syscall
	
	#Guardo 1er entero
	li $v0, 5
	syscall
	
	move $s0, $v0
	
	# Pido 2o entero
	la $a0, intro2
	li $v0, 4
	syscall

	# Guardo 2o entero
	li $v0, 5
	syscall
	
	beqz $v0, numcero
	move $s1, $v0
	
	# Variables principales
	# en s0: A
	# en s1: B
	
	# en t1: B + 1
	# en t2: AxB maximo
	# en t3: AxB actual

	# muevo B a un temporal para sumarle 1
	li $t1, 1
	
	mul $t2, $s0, $s1
	# Mensaje final
	
	la $a0, result
	li $v0, 4
	syscall
	
	
pmul:	
	# mult A x Bactual
	# comparar
	# si menor que max_mult:
	# print mult \n
	# bactual += 1
	# si mayor o igual
	# acabar programa
	
	mul $t3, $s0, $t1
	bgt $t3, $t2, endop
	
	# print mult
	
	move $a0, $t3
	li $v0, 1
	syscall
	
	# print \n
	li $a0, 10
	li $v0, 11
	syscall
	
	# Bactual += 1
	addi $t1, $t1, 1
	
	# loop!
	b pmul
	
	
endop:	li $v0, 10
	syscall	
	
numcero:
	la $a0, bcero
	li $v0, 4
	syscall
	
	b endop