	.text
	// address of the HEX displays 
	.equ ADDR1, 0xFF200020
	.equ ADDR2, 0xFF200030
	// equivalent 7-segment encoding of each number
	.equ ZERO, 0b00111111
	.equ ONE, 0b00000110
	.equ TWO, 0b01011011
	.equ THREE, 0b01001111
	.equ FOUR, 0b01100110
	.equ FIVE, 0b01101101
	.equ SIX, 0b01111101
	.equ SEVEN, 0b000000111
	.equ EIGHT, 0b01111111
	.equ NINE, 0b01101111
	.equ A, 0b01110111
	.equ ELEVEN, 0b00111101
	.equ C, 0b00111001
	.equ D, 0b01011110
	.equ E, 0b01111001
	.equ F, 0b01110001
	.global HEX_clear_ASM
	.global HEX_flood_ASM
	.global HEX_write_ASM

HEX_flood_ASM: // turn on all segments of selected HEX displays
	LDR R1, =ADDR1		// load address of first 4 HEX displays
	LDR R3, [R1]		// current status of HEX display 
	MOV R2, #0b01111111	// the bit sequence to flood one HEX display
	// check which displays are selected, and compile the instructions for each display into one 
	// 32-bit instruction, then write into I/O register
	TST R0, #1
	ORRNE R3, R3, R2
	TST R0, #2
	ORRNE R3, R3, R2, LSL #8
	TST R0, #4
	ORRNE R3, R3, R2, LSL #16
	TST R0, #8
	ORRNE R3, R3, R2, LSL #24
	STR R3, [R1]	// write
	
	LDR R1, =ADDR2	// address of HEX displays 4 and 5
	LDR R3, [R1]	// current status of HEX displays 4 and 5
	// check which displays are selected, and compile the instructions for each display into one 
	// 32-bit instruction, then write into I/O register
	TST R0, #16
	ORRNE R3, R3, R2
	TST R0, #32
	ORRNE R3, R3, R2, LSL #8
	STR R3, [R1]	// write

	B DONE

HEX_clear_ASM:
	LDR R1, =ADDR1	
	MOV R2, #0xFF	// one copy of the 11111111 for a single HEX display
	LDR R3, [R1]	// load current configuration of HEX displays
	// check which HEX display is selected
	TST R0, #1
	BICNE R3, R3, R2	// the target 8-bit segement would be 0s and rest would be 1s. AND would then clear the segments that correspond to 0.
	TEQ R0, #2
	BICNE R3, R3, R2, LSL #8
	TEQ R0, #4
	BICNE R3, R3, R2, LSL #16
	TST R0, #8
	BICNE R3, R3, R2, LSL #24
	STR R3, [R1]	

	// similar operation as above but for HEX displays 4 and 5
	LDR R1, =ADDR2
	LDR R3, [R1]	
	TST R0, #16
	BICNE R3, R3, R2
	TST R0, #32
	BICNE R3, R3, R2, LSL #8
	STR R3, [R1]	

	B DONE

HEX_write_ASM:
	// check which value is to be written
	TEQ R1, #0
	LDREQ R2, =ZERO
	TEQ R1, #1
	LDREQ R2, =ONE	
	TEQ R1, #2
	LDREQ R2, =TWO
	TEQ R1, #3
	LDREQ R2, =THREE
	TEQ R1, #4
	LDREQ R2, =FOUR
	TEQ R1, #5
	LDREQ R2, =FIVE	
	TEQ R1, #6
	LDREQ R2, =SIX	
	TEQ R1, #7
	LDREQ R2, =SEVEN	
	TEQ R1, #8
	LDREQ R2, =EIGHT	
	TEQ R1, #9
	LDREQ R2, =NINE	
	TEQ R1, #10
	LDREQ R2, =A	
	TEQ R1, #11
	LDREQ R2, =ELEVEN	
	TEQ R1, #12
	LDREQ R2, =C	
	TEQ R1, #13
	LDREQ R2, =D	
	TEQ R1, #14
	LDREQ R2, =E
	TEQ R1, #15
	LDREQ R2, =F
	
	PUSH {R4}	// convention
	LDR R1, =ADDR1
	LDR R3, [R1]
	TST R0, #1
	MOVNE R4, #0xFFFFFF00
	ANDNE R3, R3, R4	// clear target display 	
	ORRNE R3, R3, R2	// update corresponding 8-bit location in instruction with new number
	TST R0, #2
	MOVNE R4, #0xFFFF00FF
	ANDNE R3, R3, R4	// clear target display 	
	ORRNE R3, R3, R2, LSL #8	
	TST R0, #4
	MOVNE R4, #0xFF00FFFF
	ANDNE R3, R3, R4
	ORRNE R3, R3, R2, LSL #16
	TST R0, #8
	MOVNE R4, #0x00FFFFFF
	ANDNE R3, R3, R4
	ORRNE R3, R3, R2, LSL #24
	STR R3,  [R1]
	
	LDR R1, =ADDR2
	LDR R3, [R1]	// current HEX displays 4 and 5
	TST R0, #16
	MOVNE R4, #0xFFFFFF00
	ANDNE R3, R3, R4
	ORRNE R3, R3, R2
	TST R0, #32
	MOVNE R4, #0xFFFF00FF
	ANDNE R3, R3, R4
	ORRNE R3, R3, R2, LSL #8
	STR R3, [R1]
	
	POP {R4}
	B DONE

DONE:
	BX LR
	.end



