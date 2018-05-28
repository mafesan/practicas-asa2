# Examen ASA2 - 13 de Diciembre de 2017
# 
# Login lab: mafesan
# Gecos: Miguel Angel Fernandez Sanchez
#
# RECUERDA __NO__ APAGAR EL EQUIPO CUANDO ACABES. PUEDES LEVANTARTE E IRTE SIN MAS.
# NO MODIFIQUES ESTAS LINEAS. REALIZA EL EJERCICIO A PARTIR DE ESTA CABECERA.
#####
	.data
msg0:	.asciiz "Introduce numero de posiciones del array: "
msg1: 	.asciiz "Introduce valor para incializar posicion: "
msg2:	.asciiz "Introduce el valor a borrar: "
valf:		.asciiz "Valor encontrado en posicion: "
notf:		.asciiz "Valor no encontrado. \n"
memerr:	.asciiz "Ups! No hay memoria. Terminando...\n"
	.text
main:
	# Pregunto al usuario numero de elementos del array
	la $a0, msg0
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	beqz $v0, endop # Si se introduce un 0, termina el programa
	move $s0, $v0	# Guardo en s0 num. de elementos del array
	
	move $a0, $s0
	jal crearArray	# crearArray(int numElementos)
	
	beqz $v0, errmem # Si no hay memoria, terminamos
	
	move $s1, $v0	# Guardo en s1 la direccion del nuevo array
	
	move $a0, $s1
	move $a1, $s0
	jal inicializar	# inicializar(int array[], int numElementos)
	
	# Preguntamos al usuario que valor quiere borrar
	
	la $a0, msg2
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	move $a0, $s1 # dir. array
	move $a1, $v0 # valor del nodo a borrar
	move $a2, $zero # empezamos  a buscar desde el principio
	move $a3, $s0	# num. elementos
	jal borrarContenido  # borrarContenido(int array[], int valor, int pos, int numElementos)
	
	# Segun lo que nos devuelva borrarContenido, imprimimos mensaje
	beq $v0, -1, borrar_fail
	
	# Si seguimos por aqui, es que lo hemos encontrado, imprimimos su posicion
	move $t0, $v0
	
	la $a0, valf
	li $v0, 4
	syscall
	
	move $a0, $t0
	li $v0, 1
	syscall
	
	# Imprimo \n
	li $a0, 10
	li $v0, 11
	syscall
	b print_array	# Saltamos a etiqueta para imprimir el array
	
borrar_fail:
	# Mensaje de "Nodo no encontrado"
	la $a0, notf
	li $v0, 4
	syscall

print_array:
	# Imprimimos el array
	move $a0, $s1
	move $a1, $s0
	jal imprimir	# imprimir(int array[], int numElementos)
	
	b endop # acabamos el programa
	
errmem:
	la $a0, memerr
	li $v0, 4
	syscall

endop:
	li $v0, 10
	syscall
	


crearArray:	
	# Si el array de enteros debe tener n posiciones, 
	# Reservamos 4*n bytes en memoria
	beqz $a0, ret_crearArray
	# Llamo a sbrk
	mul $a0, $a0, 4
	li $v0, 9
	syscall 
	# En v0 está la direccion del futuro array
ret_crearArray:
	jr $ra


inicializar:
	# Copio valores de entrada en temporales
	# (No es necesario crear pila)
	move $t0, $a0
	move $t1, $a1
	# inicializo contador
	move $t2, $zero	
askloop:
	bge $t2, $t1, ret_inic
	la $a0, msg1
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	# guardo en el array el valor
	# que ha introducido el usuario
	
	sw $v0, 0($t0)
	add $t0, $t0, 4
	addi $t2, $t2, 1
	b askloop
ret_inic:
	jr $ra


imprimir:
	move $t0, $a0
	move $t1, $a1
	
	beqz $t0, ret_imprimir	# Si la dir. del array es NULL, salgo
	move $t2, $zero # Inicializo contador
loopimp:	
	bge $t2, $t1, ret_imprimir
	# Imprimo entero
	lw $a0, 0($t0)
	li $v0, 1
	syscall
	# Imprimo salto de linea
	li $a0, 10
	li $v0, 11
	syscall
	# Avanzo posicion, sumo contador
	add $t0, $t0, 4
	addi $t2, $t2, 1
	b loopimp
ret_imprimir:
	jr $ra


borrarContenido:
	subu $sp, $sp, 32
	sw $ra, 4($sp)
	sw $fp, 8($sp)
	addiu $fp, $sp, 16
	
	# Guardo valores de entrada en la pila
	sw $a0, 0($fp)	# array
	sw $a1, 4($fp)	# valor a borrar
	sw $a2, 8($fp)	# posicion desde donde buscamos
	sw $a3, 12($fp)	# numElementos
	
	# 1. Si pos >= numElementos --> devolvemos -1
	blt $a2, $a3, check_valor # Si pos < numElementos, pasamos a condicion2
	li $v0, -1
	b ret_borrar
check_valor:
	# 2. Si array[pos] = valor a borrar --> ponemos a 0 la pos. del array
	# y devolvemos pos.
	mul $t0, $a2, 4
	add $t0, $a0, $t0 # Nos movemos a la posicion que nos han dicho
	lw $t1, 0($t0)	# Cargamos el valor de esa posicion
	beq $t1, $a1, val_found	# MIramos si el valor es el que buscamos
	# Si no, llamamos a
	# borrarContenido(int array[], int valor, int pos + 1, int numElementos)(
	lw $a0, 0($fp)
	lw $a1, 4($fp)
	lw $a2, 8($fp)
	addiu $a2, $a2, 1	# pos = pos + 1
	lw $a3, 12($fp)
	jal borrarContenido
	
	b ret_borrar
val_found:
	# Si hemos encontrado el valor, ponemos a 0 esa posicion
	# y devolvemos pos.
	# Tenemos la dir de array[pos] en t0
	sw $zero, 0($t0)	# array[pos] = 0
	lw $v0, 8($fp)	# Cargamos posicion en v0 para devolverla
	# Y salimos
ret_borrar:
	lw $fp, 8($sp)
	lw $ra, 4($sp)
	addiu $sp, $sp, 32
	jr $ra