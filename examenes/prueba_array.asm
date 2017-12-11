	.data
msg:	.asciiz "Introduce numero de posiciones del array\n"	
inic:	.asciiz "Inicializa posicion "
errm:	.asciiz "Ups! No ha memoria\n"	
	.text
	
main:
	la $a0, msg
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	move $s1, $v0
	
	mul $s2, $s1, 4 # Si el array es de n posiciones (tam. palabra), reservo 4*n bytes
	move $a0, $s2
	li $v0, 9
	syscall
	
	beqz $v0, memerr
	
	subi $s2, $s2, 4 # Porque la primera posicion empieza en 0, resto 4 al numero con el que comparo
	
	move $s0, $v0 # pongo en s0 la dir. base del array
	
	move $t0, $s0
	move $t1, $zero
loop:
	bgt $t1, $s2, printarr

	la $a0, inic
	li $v0, 4
	syscall 
	
	li $v0, 5
	syscall
	
	sw $v0, 0($t0)
	
	li $a0, 10
	li $v0, 11
	syscall

	add $t1, $t1, 4
	add $t0, $t0, $t1
	
	b loop
	
printarr:
	move $t0, $s0
	move $t1, $zero 
printloop:
	bgt $t1, $s2, endop
	
	lw $a0, 0($t0)
	li $v0, 1
	syscall
	
	li $a0, 10
	li $v0, 11
	syscall
	
	add $t1, $t1, 4
	add $t0, $t0, $t1
	
	b printloop
	
memerr:
	la $a0, errm
	li $v0, 4
	syscall
	
endop:
	li $v0, 10
	syscall
