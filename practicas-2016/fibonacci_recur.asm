	.data
msg: .asciiz "Introduce numero a calcular su Fibonacci: "
	.text
	
main:
	la $a0, msg # Message: enter number 'n' to calculate F(n)
	li $v0, 4 
	syscall 
	
	li $v0,5 # Read the value entered by user
	syscall
	
	move $a0,$v0
	jal fibon		# Call fibonacci function
	
	move $a0, $v0		# Move fact result in $a0
	li $v0, 1 		# Load syscall print-int into $v0
	syscall 		# Make the syscall
	
	li $v0, 10		# Load syscall exit into $v0
	syscall
	
fibon:  
	bgt $a0, 2, fibon_recur
	li $v0, 1
	jr $ra
	
fibon_recur:

	subu $sp, $sp, 32	# Stack frame is 32 bytes long
	sw $ra, 20($sp)		# Save return address
	sw $fp, 16($sp)		# Save frame pointer
	addiu $fp, $sp, 28	# Set up frame pointer
	sw $a0, 0($fp) 		# Save argument (n)

	subu $a0, $a0, 1	# Compute n - 1
	jal fibon
	sw $v0, 4($fp)		# Save result F(n-1)
	
	lw $a0, 0($fp)
	subu $a0, $a0, 2	# Compute n - 2
	jal fibon
	
	lw $v1, 4($fp)		# Load value F(n-1)
	add $v0,$v0,$v1		# Compute F(n-1) + F(n-2)
	
	lw $ra, 20($sp)
	lw $fp, 16($sp)
	addiu $sp, $sp, 32
	jr $ra