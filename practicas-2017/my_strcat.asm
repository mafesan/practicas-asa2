	.data
msg:	.asciiz "Introduce cadena de caracteres: "
cad1:	.space 256
cad2:	.space 256 # caracteres son de tamaño byte!!!
	.text
main:
	# Pregunto por la primera cadena
	la $a0, msg
	li $v0, 4
	syscall
	
	la $a0, cad1
	li $a1, 256
	li $v0, 8
	syscall
	
	# Pregunto por la segunda cadena
	la $a0, msg
	li $v0, 4
	syscall
	
	la $a0, cad2
	li $a1, 256
	li $v0, 8
	syscall	
	
	# Llamo a concatenate(cad1, cad2)
	la $a0, cad1
	la $a1, cad2
	jal concatenate
	
	# Imprimo
	la $a0, cad1
	li $v0, 4
	syscall
	
	b endop
	
concatenate: # concatenate(str1, str2)
	subu $sp, $sp, 32
	sw $ra, 4($sp)
	sw $fp, 8($sp)
	addiu $fp, $sp, 16
	
	sw $a0, 0($fp)
	sw $a1, 4($fp)

	# Busco final de str1
searchend1:
	lb $t2, 0($a0)
	# Si no considero \n, comparo con 10 (ASCII)
	# Si quiero considerarlo, comparo con 0 (beqz)
	beq $t2, 10, endstr1 
	addiu $a0, $a0, 1
	b searchend1
	
endstr1:

concatstr2:
	# Recorro str2
	lb $t4, 0($a1)
	beqz $t4, retconcat
	sb $t4, 0($a0)
	addiu $a0, $a0, 1
	addiu $a1, $a1, 1
	b concatstr2
	
retconcat:
	lw $ra, 4($sp)
	lw $fp, 8($sp)
	addiu $sp, $sp, 32
	jr $ra
	
endop:
	li $v0, 10
	syscall	
