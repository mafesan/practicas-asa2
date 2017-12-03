.data
str: 	.asciiz "Introduce un entero: (0 para terminar) \n"
	.text
main: la $a0, str
		li $v0, 4
		syscall
		li $v0, 5
		syscall
		move $t0, $v0
		move $a0, $t0
		li $a1, 0
		jal create
		move $s0, $v0
		move $s1, $v0
		print2:
		#introduzco nuevo numero
		la $a0, str
		li $v0, 4
		syscall
		li $v0, 5
		syscall
		move $s7, $v0 # para comprobar si el valor es un cero
		move $a0, $s1	# ultimo nodo
		move $a1, $v0	# nuevo valor
		jal insert
		move $s1, $v0
		bnez $s7, print2
		move $a0, $s0
	
		jal print
		li $v0, 10
		syscall
		
		
		create:
			move $t0, $a0
			li $v0, 9
			li $a0, 8
			syscall
			# falta por comprobar si no hay memoria
			
			
			sw $t0, 0($v0) #primera palabra valor pos 0
			sw $a1, 4($v0) #segunda palabra segundo argumento puntero
			
			jr $ra
		
		insert:
			#guardar en pila
			subu $sp, $sp, 32
			sw $ra, 20($sp)
		
			move $t1, $a0 # $a0 es el nodo anterior y lo paso a un temporal
			move $t0, $a1 # $a1 valor actual
			
			move $a0, $t0 # $a0 pasa a valer el valor
			move $a1, $t1 # $a1 pasa a valer el nodo anterior
			
			jal create
			
			sw $v0, 4($a1) # a la salida de create asigno la direccion del nodo actual que sale de $v0 al parametro 2 del nodo anterior
			
			
			lw $ra, 20($sp) #recupero $ra de la pila y libero pila
			addiu  $sp, $sp, 32
			jr $ra
			
		print:
			move $t0, $a0
			loop:
				lw $a0, 0($t0)
				li $v0, 1
				syscall
				
				lw $t0, 4($t0)
				bnez $t0, loop
			jr $ra