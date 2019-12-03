	.text
	.equ AD_CONTROL, 0xFF203040
	.equ AD_FIFO, 0xFF203044
	.equ AD_L, 0xFF203048
	.equ AD_R, 0xFF20304C
	.global audio_write_ASM
	
audio_write_ASM:
// Takes one integer argument and write to both left and right FIFOs
	
	// load the address of the FIFO buffer into R1
	LDR R1, =AD_FIFO
	LDR R1, [R1]
	
	// put WSLC in R2 and WSRC in R1
	LSR R1, R1, #16	// WSRC
	LSR R2, R1, #8	// WSLC	
	AND R1, R1, #0xFF

	// check if either buffer is full
	CMP R1, #0	// check if there is space in WSRC
	CMPNE R2, #0	// only check R2 (WSLC) if there is space available in R1 (WSRC)
	MOVEQ R0, #0	// 0 indidcates fail
	BXEQ LR		// exit

	// there is space, write to L and R FIFOs
	LDR R1, =AD_L
	LDR R2, =AD_R
	STR R0, [R1]
	STR R0, [R2]

	MOV R0, #1	// 1 indicates successful operation
	BX LR

	.end
	

