/*
	C�digo pra c�lculo de CRC com mensagem de at� 28 bits (pra acrescentar os 4 bits 0 do polin�mio 
	e ainda caber em um registrador s�) e polin�mio de grau 4
	Pode melhorar (bastante), acho que pode reduzir uns loops, mas t� funcionando 
*/

	.data

	.equ MSG, 16512891 # Mensagem 
	.equ MAX, 2147483648 # 2 ^ 31 pra checar se o primeiro bit � um. Bin�rio: 10000000 00000000 00000000 00000000
	.equ MASKMSG, 4294967295 # M�scara pra saber quando parar a divis�o
	
	va: .word MSG # armazena mensagem de entrada na mem�ria
	vb: .word MAX
	masc: .word MASKMSG # m�scara de bits
	
	.text

# r4: Contador | r5: Endere�os | r7 : Mensagem | r9 : Polinomio Gerador | r10 : Armazena valor 2 ^ 31 pra compara��es | r11 : Resultado do XOR | r12 : M�scara de bits
	
movia r5, va
ldw r7, 0 (r5) # coloca o valor da mensagem que est� na mem�ria no registrador r7
movia r5, vb
ldw r10, 0 (r5) 
movia r5, masc
ldw r12, 0(r5)

movi r9, 0b10011 # polin�mio gerador

mov r4, r0 

slli r9, r9, 4 
slli r12, r12, 4
slli r7, r7, 4 # shift 4 bits. Adicionando os zeros correspondentes ao grau do polin�mio � mensagem. 

loop:
	bltu r7, r10, checa_zero
	bgeu r7, r10, continua

checa_zero: 
	bgtu r7, r0, conta
	
conta: 
	slli r7, r7, 1
	addi r4, r4, 1
	bgeu r7, r10, continua
	br loop
	
continua:
	srl r7, r7, r4
	br loop_poly
	
# faz a xor entre o polin�mio e a mensagem continuamente, substituindo o valor da msg 
# pelo resultado da xor at� que todos os bits da mensagem original sejam iguais a 0 

continua2: 		
	srl r9, r9, r4  
	xor r11, r9, r7
	mov r7, r11
	and r14, r12, r7
	xor r4, r4, r4
	beq r14, r0, fim
	br loop
	
loop_poly: 
	bltu r9, r10, checa_zero_poly
	bgeu r9, r10, continua2

checa_zero_poly:
	bgtu r9, r0, conta_poly

conta_poly:
	slli r9, r9, 1
	bgeu r9, r10, continua2
	br loop_poly
fim:

