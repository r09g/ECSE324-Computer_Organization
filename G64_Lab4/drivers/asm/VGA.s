		.text
		.equ PXBB, 0xC8000000
		.equ CHARBUF_BASE, 0xC9000000
		.equ OFFSET1, 0b1001111100
		.equ OFFSET2, 0b11110000
		.equ OFFSET3, 0b10000000000
		.global VGA_clear_charbuff_ASM
		.global VGA_clear_pixelbuff_ASM
		.global VGA_write_char_ASM
		.global VGA_write_byte_ASM
		.global VGA_draw_point_ASM

// ---------------------------------------------------------------------------------------------------
VGA_clear_charbuff_ASM:
	PUSH {LR}			
	LDR R0, =CHARBUF_BASE		// base address
	MOV R1, #0			// used to store into memory
	MOV R2, #80			// counter for x direction
	MOV R3, #60			// counter for y direction

LOOP_Y:
// loop Y, clear each row	
	SUBS R3, R3, #1		// counter
	POPLT {LR}
	BXLT LR				// cleared
	BL LOOP_X			// clear in x direction
	SUB R0, R0, #80			// reset address in x direction
	ADD R0, R0, #0x80		// increment address in y direction since 8th bit is for y
	MOV R2, #80			// reset x direction counter
	B LOOP_Y			// repeat

LOOP_X: 
// subroutine to clear a row (in x direction)
	SUBS R2, R2, #4			// decrement counter
	BXLT LR				// finished row
	STR R1, [R0], #4		// store 32 bits of 0 into address with increment 4 bytes
	B LOOP_X			// repeat


// ---------------------------------------------------------------------------------------------------
VGA_clear_pixelbuff_ASM:
	LDR R0, =PXBB 
	LDR R1, =OFFSET1 //counter for x (for horizontal clear); modified because we store 32 bit at a time; decrement by 4 each time 
	LDR R2, =OFFSET2 //counter for y (for vertical clear); decrement by 1 each time 
	MOV R3, #0 //use 0 to clear
	PUSH {LR}
	BL CLEAR_HORIZONTAL //start by clearing the last row
	POP {LR}
	BX LR

CLEAR_HORIZONTAL: 
	CMP R1, R3 //test whether the counter decrement to 0; R3 stores 0
	STRGE R3, [R0, R1] //store 0 to this raw from the end to the beginning
	SUBGE R1, R1, #4 //decrement counter
	BLT GET_NEXT_ROW //if the whole row is cleared, clear the previous row
	B CLEAR_HORIZONTAL 

GET_NEXT_ROW:
	CMP R2, R3 //check the counter
	SUBGT R2, R2, #1 //update the counter
	LDRGT R1, =OFFSET3
	ADDGT R0, R0, R1 //make R0 to store the address of the first column, previous row
	LDRGT R1, =OFFSET1
	BGT CLEAR_HORIZONTAL
	BXLE LR



// ---------------------------------------------------------------------------------------------------
VGA_write_char_ASM:
// writes a character (ASCII in R2) in x (R0) and y (R1) location
	// check if x and y are within range
	// x = [0, 79]; y = [0, 59]
	CMP R0, #79
	CMPLE R1, #59
	BXGT LR

	LDR R3, =CHARBUF_BASE
	LSL R1, R1, #7 // adjust offset in y to the correct value (offset in y is specified starting from bit 7)
	ADD R3, R3, R1 // increment in y direction
	ADD R3, R3, R0 // increment in x direction
	STRB R2, [R3]
	BX LR		

// ---------------------------------------------------------------------------------------------------
VGA_write_byte_ASM:
// writes two characters (R2) in x (R0) and y (R1) location
	// check if x and y are within range
	// check y first
	CMP R1, #59
	// if y = 59, x < 78 to leave 2 characters at the end
	CMPEQ R0, #78
	// if y < 59, x < 79 since the second character can wrap
	CMPLT R0, #79
	BXGT LR

	PUSH {R4-R5}
	LSR R4, R2, #4 // R4 contains the first character
	AND R4, R4, #0xF 
	AND R5, R2, #0xF // R5 contains the second character
	// convert to ASCII code
	CMP R4, #9
	ADDLE R4, R4, #48	// ASCII code conversion for 0 - 9
	ADDGT R4, R4, #55	// ASCII code conversion for A - F
	CMP R5, #9		// similar operation for R5
	ADDLE R5, R5, #48
	ADDGT R5, R5, #55
	// determine address
	LDR R3, =CHARBUF_BASE
	LSL R1, R1, #7
	ADD R3, R3, R1
	ADD R3, R3, R0
	STRB R4, [R3]
	CMP R0, #79		// is it the right most column?
	BICEQ R3, R3, #0b1111111	// write to the next row in the first column
	ADDEQ R3, R3, #0x80
	ADDNE R3, R3, #1
	STRB R5, [R3]
	POP {R4-R5}
	BX LR

// ---------------------------------------------------------------------------------------------------

VGA_draw_point_ASM:
// R0: x; R1: y; R2: colour (2 byte RGB value)
		LSL R0, R0, #1			
		LSL R1, R1, #10				
		ORR R0, R0, R1				//calculate the offset
		LDR R1, =PXBB 				
		STRH R2, [R1, R0]
		BX LR			

DONE:
		.end

