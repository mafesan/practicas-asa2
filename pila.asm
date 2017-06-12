# Examen ASA-II - 7 de Diciembre de 2016
# 
# Login lab: mafesan
# Gecos: Miguel Angel Fernandez Sanchez
#
# RECUERDA __NO__ APAGAR EL EQUIPO CUANDO ACABES. PUEDES LEVANTARTE E IRTE SIN MAS.
# NO MODIFIQUES ESTAS LINEAS. REALIZA EL EJERCICIO A PARTIR DE ESTA CABECERA.
#####

#FUNCIONAN CREATE E INSERT. PRINT IMPRIME LA LISTA AL REVES. REMOVE NO FUNCIONA
	.data
	
pedir_num: .asciiz "Introduce un entero:\n"
pedir_rm: .asciiz "Introduce el entero a eliminar:\n"
no_rm_pila: .asciiz "El nodo a eliminar esta en la cima. No se puede eliminar. \n"

	.text

main:
	# Reservo memoria para tener la cima de la pila
	li $a0, 8
	li $v0, 9
	syscall
	beqz $v0, end_program	# Cambair
	move $s0, $v0	# Cima de la pila
	# Inicializo pila
	sw $zero, 0($s0)
	sw $zero, 4($s0)
pedir_entero:	
	la $a0, pedir_num
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	beqz $v0, end_to_print
	
	# Preparo funcion push_node(top, val)
	move $a0, $s0	#CIma de la pila
	move $a1, $v0	#Valor introducido
	jal push
	move $s0, $v0	# Actualizo $s0 con la nueva cima de la pila
	
	b pedir_entero
	
end_pedir_entero:
	# Preparo remove(top, val)
	la $a0, pedir_rm
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	move $a0, $s0
	move $a1, $v0 
	#jal remove
	#Falta resultado del remove
end_to_print:	
	move $a0, $s0
	jal print_pila
	li $v0, 10
	syscall

remove:
	# Guardar esto en pila
	subu $sp, $sp, 32
	sw $fp, 16($sp)
	sw $ra, 20($sp)
	addiu $fp, $sp, 24
	
	
push:
	subu $sp, $sp, 32
	sw $fp, 16($sp)
	sw $ra, 20($sp)
	addiu $fp, $sp, 24	
	
	move $t0, $a0 # CIma de la pila
	move $t1, $a1	# Valor a introducir
	
	#Llamo a create_node(val, prev)
	move $a0, $t1
	move $a1, $t0
	jal create
	# $v0 sigue teniendo la direccion del nuevo nodo creado
	# Restauro $ra, y vuelvo a donde me llamaron
	lw $fp, 16($sp)
	lw $ra, 20($sp)
	addiu $sp, $sp, 32
	jr $ra
	
create:
	
	move $t0, $a0
	# Pido memoria
	li $a0, 8
	li $v0, 9
	syscall
	beqz $v0, end_program	# Cambair
	# Me devuelven memoria en $v0
	sw $t0, 0($v0)	#Guardo valor en nueva direccion(0-4)
	sw $a1, 4($v0)	# Guardo previo en nueva direccion(4-8)
	# Devuelvo direccion del nodo creado en $v0
	jr $ra
	
	
print_pila:
	subu $sp, $sp, 32
	sw $fp, 16($sp)
	sw $ra, 20($sp)
	addiu $fp, $sp, 24	
	
	sw $a0, 0($fp)
	lw $t0, 0($a0)	#Cargas valor
	lw $t1, 4($a0)	#Cargas previo

	beqz $t1, back
	move $a0, $t0
	li $v0, 1
	syscall
	move $a0, $t1
	jal print_pila

back:	
	lw $a0, 0($fp)
	lw $fp, 16($sp)
	lw $ra, 20($sp)
	addiu $sp, $sp, 32
	jr $ra

end_program:

	li $v0, 10
	syscall
	
	
