	.text
	.equ LED_ADDR, 0xFF200000
	.global read_LEDs_ASM

read_LEDs_ASM:
	LDR 	R0, =LED_ADDR
	LDR 	R0, [R0]
	BX	LR
	.end
