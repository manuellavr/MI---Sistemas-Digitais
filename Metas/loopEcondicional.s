######################################################
# Multiplica dois valores (r3 e r4)
# utilizando instruções de soma
######################################################

movi r3, 5
movi r4, 14
movi r5, 0

loop: 
	bge r5, r4, fim 	# para o loop quando o valor de r5 se torna igual ao de r4 
	add r6, r6, r3
	addi r5, r5, 1		
	br loop
	
fim: 


