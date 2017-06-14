.data
msg1:	.asciiz "Introduzca el primer valor: "
msg2:	.asciiz "Introduzca valor (0 para salir): "
msg3:	.asciiz "Imprimimos... "
sep:	.asciiz " "

.text

main:	la $a0, msg1
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	move $a0, $v0	#param1: valor
	move $a1, $zero	#param2: nodo*next
	
	jal create
	
	move $s0, $v0

loopI:	la $a0, msg2
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	beqz $v0, exitLI
	
	move $a0, $s0	#param1: nodo*first
	move $a1, $v0	#param2: valor
	
	jal insert_in_order
	
	beqz $v0, noChange
	move $s0, $v0	#Cambiamos primer nodo	
	b loopI

noChange:	b loopI	

exitLI:	la $a0, msg3
	li $v0, 4
	syscall
	
	move $a0, $s0	#param1: nodo*First
	
	jal print

	li $v0, 10
	syscall
	
	
create:	subu $sp, $sp, 32
	sw $ra, 0($sp)
	sw $fp, 4($sp)
	addiu $fp, $sp, 28
	
	sw $a0, 0($fp)	#Guardamos en marco de pila
	sw $a1, -4($fp)
	
	li $a0, 8	#SRBK - Nuevo nodo
	li $v0, 9
	syscall
	
	lw $a0, 0($fp)	#sacamos del marco de pila
	lw $a1, -4($fp)
	
	sw $a0, 0($v0)	#Guardamos en el nodo
	sw $a1, 4($v0)
	
	lw $ra, 0($sp)
	lw $fp, 4($sp)
	addiu $sp, $sp, 32
	jr $ra
	
insert_in_order:	subu $sp, $sp, 32
			sw $ra, 0($sp)
			sw $fp, 4($sp)
			addiu $fp, $sp, 28

insert:			lw $t0, 0($a0)	#sacamos valor del primer nodo
			lw $t1, 4($a0)	#sacamos nodo*next
			bgt $a1, $t0, insert_first	#valor mayor que el primero			
			beqz $t1, insert_last		#valor menor de todos
			lw $t2, 0($t1)
			bgt $a1, $t2, insert_in		#insertar entre 2 numeros

			move $a0, $t1	#pasamos al siguiente nodo
			b insert
			
insert_first:		move $t0, $a0	#pasamos direccion a t0 para pasarlo a a1

			move $a0, $a1	#param1: valor
			move $a1, $t0	#param2: nodo*next
			
			jal create
			
			b exit_insert

insert_last:		sw $a0, 0($fp)	#guardamos en pila

			move $a0, $a1	#param1: valor
			move $a1, $zero	#param2: nodo^next
			
			jal create
			
			lw $a0, 0($fp)	#saco de la pila
			sw $v0, 4($a0)	#guardo el nodo nuevo en el nodo*next anterior
			
			move $v0, $zero	#no modificamos el primer nodo
			
			b exit_insert

insert_in:		sw $a0, 0($fp)	#guardamos en pila la direccion nodo*last
			
			move $a0, $a1	#param1: valor	
			move $a1, $t1	#param2: nodo*next
			
			jal create
			
			lw $a0, 0($fp)	#saco de la pila
			sw $v0, 4($a0)	#Guardamos nodo creado en nodo*next anterior
			
			move $v0, $zero	#no modificamos el primer nodo
			 			
exit_insert:		lw $ra, 0($sp)
			lw $fp, 4($sp)
			addiu $sp, $sp, 32
			jr $ra
			
			
print:	subu $sp, $sp, 32
	sw $ra, 0($sp)
	sw $fp, 4($sp)
	addiu $fp, $sp, 28

	sw $a0, 0($fp)
	
	lw $t0, 4($a0)		#saco nodo*next
	beqz $t0, goPrint
	
	move $a0, $t0	#pasamos al nodo siguiente
	
	jal print
	
goPrint:	lw $a0, 0($fp) #sacamos de la pila

		lw $t0, 0($a0)	#sacamos valor
		move $a0, $t0	#Imprimimos
		li $v0, 1
		syscall
		
		la $a0, sep
		li $v0, 4
		syscall
									
		lw $ra, 0($sp)
		lw $fp, 4($sp)
		addiu $sp, $sp, 32
		jr $ra