/*
	Código pra cálculo de CRC com mensagem de até 28 bits (pra acrescentar os 4 bits 0 do polinômio 
	e ainda caber em um registrador só) e polinômio de grau 4
	Pode melhorar (bastante), acho que pode reduzir uns loops, mas tá funcionando 
*/

	.data

	.equ MSG, 16512891 # Mensagem 
	.equ MAX, 2147483648 # 2 ^ 31 pra checar se o primeiro bit é um. Binário: 10000000 00000000 00000000 00000000
	.equ MASKMSG, 4294967295 # Máscara pra saber quando parar a divisão
	
	va: .word MSG # armazena mensagem de entrada na memória
	vb: .word MAX
	masc: .word MASKMSG # máscara de bits
	
	.text

# r4: Contador | r5: Endereços | r7 : Mensagem | r9 : Polinomio Gerador | r10 : Armazena valor 2 ^ 31 pra comparações | r11 : Resultado do XOR | r12 : Máscara de bits
	
movia r5, va
ldw r7, 0 (r5) # coloca o valor da mensagem que está na memória no registrador r7
movia r5, vb
ldw r10, 0 (r5) 
movia r5, masc
ldw r12, 0(r5)

movi r9, 0b10011 # polinômio gerador

mov r4, r0 

slli r9, r9, 4 
slli r12, r12, 4
slli r7, r7, 4 # shift 4 bits. Adicionando os zeros correspondentes ao grau do polinômio à mensagem. 

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
	
# faz a xor entre o polinômio e a mensagem continuamente, substituindo o valor da msg 
# pelo resultado da xor até que todos os bits da mensagem original sejam iguais a 0 

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

