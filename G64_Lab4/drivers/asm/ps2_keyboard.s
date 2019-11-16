	.text
	.equ PS2_DATA, 0xFF200100
	.global read_PS2_data_ASM

read_PS2_data_ASM:
	LDR R1, =PS2_DATA
	LDR R1, [R1]
	LSR R2, R1, #15
	TST R2, #1
	MOVEQ R0, #0
	BXEQ LR
	AND R1, R1, #0xFF
	STR R1, [R0]
	MOV R0, #1
	BX LR
.end