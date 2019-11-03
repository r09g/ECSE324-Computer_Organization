	.text
	.equ PB_ADDR, 0xFF200050
	.equ INTR_ADDR, 0xFF200058
	.equ EC_ADDR, 0xFF20005C
	.equ SW_BASE, 0xFF200040
	.global read_PB_data_ASM
	.global PB_data_is_pressed_ASM
	.global read_PB_edgecap_ASM
	.global PB_edgecap_is_pressed_ASM
	.global PB_clear_edgecap_ASM
	.global enable_PB_INT_ASM
	.global disable_PB_INT_ASM	

read_PB_data_ASM:	// reads all PB states
	LDR R0, =PB_ADDR	// load pushbutton address
	LDR R0, [R0]		// load pushbutton status from address
	AND R0, R0, #0b1111	// extract only lowest 4 bits
	
	B DONE

PB_data_is_pressed_ASM:	
	// return int containing the one-hot encoding of the pressed buttons
	// able to test multiple pushbuttons at once
	LDR R1, =0xFF200050	// LOAD PB ADDRESS INTO REGISTER
	LDR R1, [R1]		// READ PUSHBUTTONS
	AND R1, R1, #0b1111	// CLEAR UNUSED BITS
	
	AND R0, R0, #0b1111	// extract only lowest 4 bits
	AND R1, R1, R0		// polled PB will be 1 and if PB is pressed they will also be 1. AND will return 1 if both are 1.
	CMP R1, #0
	MOVNE R0, #1		// if there is one or more matches, return 1
	MOVEQ R0, #0		// no match, return 0
	
	B DONE

read_PB_edgecap_ASM:		// reads the edgecapture registers of the pushbuttons
	LDR R0, =EC_ADDR	// load edgecapture register address into register
	LDR R0, [R0]		// load edgecapture register data
	AND R0, R0, #0b1111	// clear unwanted bits
	
	B DONE

PB_edgecap_is_pressed_ASM:
	// return int containing the one-hot encoding of the buttons that have been pressed
	// able to check multiple pushbuttons at once
	LDR R1, =EC_ADDR	// load address into register
	LDR R1, [R1]		// load edge capture register data
	AND R1, R1, #0b1111	// clear any unwanted bits
	AND R1, R1, R0		// AND operation with polled PBs and edgecapture register to determine the desired edgecapture bits
	CMP R1, #0		
	MOVNE R0, #0		// return true (1) if button pressed
	MOVEQ R0, #1		// return false (0) if button not pressed

	B DONE

PB_clear_edgecap_ASM:		// clear edgecapture register
	LDR R1, =EC_ADDR
	MVN R2, #0
	// writing to the edgecapture register would clear all edgecapture register values
	STR R2, [R1]

	B DONE

enable_PB_INT_ASM:
	LDR R1, =INTR_ADDR	// load the interrupt address
	LDR R2, [R1]		// load the interrupt register value
	AND R2, R2, #0b1111	// clear unwanted bits
	AND R0, R0, #0b1111	
	ORR R2, R2, R0		// change the bit of desired PBs from 0 to 1 in interrupt register
	STR R2, [R1]		// write to interrupt register
	
	B DONE

disable_PB_INT_ASM:
	LDR R1, =INTR_ADDR	// load the interrupt address
	LDR R2, [R1]		// load the interrupt register value
	AND R0, R0, #0b1111	// clear any wanted bits
	AND R2, R2, #0b1111
	BIC R2, R2, R0		// the bits to clear are labelled as "1" in R0		
	STR R2, [R1]		// write to interrupt register

	B DONE

DONE:	
	BX LR
	.end


 
