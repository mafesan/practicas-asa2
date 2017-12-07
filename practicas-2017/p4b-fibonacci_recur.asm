	.data
msg:	.asciiz "Introduce el numero a calcular su Fibonacci: \n"
	.text
main:
	# Print message
	la $a0, msg
	li $v0, 4
	syscall
	
	# Read integer n
	li $v0, 5
	syscall
	move $a0, $v0
	
	# Compute Fibonacci(n)
	jal fibon
	
	# Print result
	move $a0, $v0
	li $v0, 1
	syscall
endop:
	# End program
	li $v0, 10
	syscall
	
fibon:
	bge $a0, 2, fibon_recur
	li $v0, 1
	b return_fibon
	
fibon_recur:
	subu $sp, $sp, 32
	sw $ra, 20($sp)
	sw $fp, 16($sp)
	addiu $fp, $sp, 24
	sw $a0, 0($fp)
	
	subu $a0, $a0, 1
	jal fibon

	sw $v0, 4($fp)
	
	lw $a0, 0($fp)
	subu $a0, $a0, 2
	jal fibon
	
	lw $t0, 4($fp)
	add $v0, $v0, $t0
	
	lw $ra, 20($sp)
	lw $fp, 16($sp)
	addiu $sp, $sp, 32
return_fibon:
	jr $ra