	.text
	.equ LEDs, 0xFF200000		// LED I/O register address
	.global read_LEDs_ASM
	.global write_LEDs_ASM

read_LEDs_ASM:
	LDR R1, =LEDs		// load LED address
	LDR R0, [R1]		// load LED status
	BX LR

	B DONE

write_LEDs_ASM:
	LDR R1, =LEDs		// load LED address
	STR R0, [R1]		// store new state in LED address
	BX LR
	
DONE:
	.end
