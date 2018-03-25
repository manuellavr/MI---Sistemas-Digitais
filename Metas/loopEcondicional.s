######################################################
# Multiplica r3 por r4 utilizando instruções de soma
######################################################

movi r3, 5
movi r4, 12
movi r5, 0

loop: 
	bge r5, r4, parar
	add r6, r6, r3
	addi r5, r5, 1
	br loop
	
parar: 


