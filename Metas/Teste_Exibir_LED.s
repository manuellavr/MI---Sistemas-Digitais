	.data
	
	.equ end_LED, 0x810
	.equ end_botao, 0x840
	.equ dados, 0b10111101111101001011011011010111
	
	.text
	
main:
	movia r8, end_LED
	movia r9, end_botao
	movia r10, dados
	roli r10, r10, 4
	stw r10, 0(r8)
	movi r13, 0x1
	
loop: 
	ldb r12, 0(r9) # pegando dados do botão
	movi r14, 100
	beq r12, r13, desloca 
	br loop
	
desloca:
	roli r10, r10, 4
	stw r10, 0(r8)
	delay: 
		subi r14, r14, 1
		bne r14, r0, delay
	br loop