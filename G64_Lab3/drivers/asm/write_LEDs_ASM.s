	.text
	.equ LED_ADDR, 0xFF200000
	.global write_LEDs_ASM

write_LEDs_ASM:
	LDR 	R1, =LED_ADDR
	STR 	R0, [R1]
	BX	LR
	.end
