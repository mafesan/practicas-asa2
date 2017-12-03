	.data
mytext:	.space 1024
introt:	.asciiz "Introduce la cadena de caracteres: \n"
posit:	.asciiz "La cadena es un palindromo \n"		
negat: .asciiz "La cadena no es un palindromo \n"
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
	
	# Recorro string buscando ultima posicion (\0)
	
nextc:	lb $t1, 0($t0)
	beqz $t1, checkpal
	addi $t0, $t0, 1
	
	b nextc

checkpal:
	
	addi $s1, $t0, -2 # guardo en s1 la posicion del ultimo char
		
	move $t0, $s0
	move $t1, $s1
	
loop:	
	lb $t2, 0($t0)
	lb $t3, 0($t1)
	bne $t2, $t3, noes
	bge $t0, $t1, sies
	
	addi $t0, $t0, 1
	addi $t1, $t1, -1
	b loop
	
sies:
	la $a0, posit
	li $v0, 4
	syscall
	b endop
noes:
	la $a0, negat
	li $v0, 4
	syscall
		
endop: 
	li $v0, 10
	syscall
	
traza1: # para debug
	lb $t1, 0($t0)
	beqz $t1, checkpal
	addi $t0, $t0, 1
	
	# traza 1
	move $a0, $t1
	li $v0, 11
	syscall
	
	li $a0, 10
	li $v0, 11
	syscall
	# end of traza1
	
	b traza1
