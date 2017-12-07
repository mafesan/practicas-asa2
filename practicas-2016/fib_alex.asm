#FIbonacci

	.data
msg: .asciiz "Introduce numero a calcular su Fibonacci: "
	.text
	
main:
	la $a0, msg #Mensaje para introducir fibonacci
	li $v0, 4 
	syscall 
	
	li $v0,5 # Leemos el numero introducido por el usuario.
	syscall
	
	move $a0,$v0
		
	jal fib
	
	move $a0, $v0 # El resultado del fibonacci lo pasare por v0
	
	li $v0, 1 # Para imprimir el resultado
	
	syscall # Make the syscall
	
	
	li $v0,10
	syscall
	

fib:
	bgt $a0,2,fib_recur
	li $v0,1
	jr $ra
	
	  
fib_recur:
	
	subu $sp, $sp, 32 #Desplazo stack pointer.
	sw $ra, 20($sp) # Guardo la dirección de retorno
	sw $fp, 16($sp) # Guardo frame pointer
	addiu $fp, $sp, 24 # Subo a casi cima de la pila el fp, dejo 2 espacios para preservar 2 valores
	sw $a0, 0($fp) # Guardo a0 en cima de fp
	
	subi $a0,$a0,1 #resto 1

	jal fib
	
	sw $v0,4($fp) #LInea X guardo el número menos 1
	
	lw $a0,0($fp) #Aqui esta el numero introducido si fuese 3.
	
	subi $a0,$a0,2 #resto 2 al número
	
	jal fib
	
	lw $t0, 4($fp) #Cargo el resultado que tenia de antes, el vo de la Linea X
	
	add $v0,$t0,$v0
	
	lw $ra, 20($sp)
	lw $fp, 16($sp)
	addiu $sp, $sp, 32
	jr $ra
	
	
		      	      
	
		
