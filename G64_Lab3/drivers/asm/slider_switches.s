	.text
	.equ SW_BASE, 0xFF200040	// address of slider switch I/O register
	.global read_slider_switches_ASM

read_slider_switches_ASM:
	LDR R1, =SW_BASE		// load slider switch address
	LDR R0, [R1]			// load slider switch status from address
	BX LR
	.end