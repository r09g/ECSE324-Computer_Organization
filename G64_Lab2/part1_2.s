// This program finds the minimum element in a list of numbers and stores the result in R1
// Date: 20191018
// Author: Raymond Yang, Chang Zhou
			.text
			.global _start

_start:
			LDR R3, =RESULT				// R3 points to the memory location of RESULT
			LDR R2, [R3, #4]!			// R2 holds the number of entries in the list, writeback is used, R4 is increment by 1 word
			LDR R0, [R3, #4]!			// R0 holds the first number in the list, writeback is used, R4 is increment by 1 word
			BL 	SUBROUTINE				// call subroutine, link register stores address of next instruction
			B	END						// program ends

SUBROUTINE: 
			SUBS R2, R2, #1				// decrement entries counter and update conditional code flags
			BXEQ LR						// go back to calling instruction when R2 = 0
			LDR R1, [R3, #4]!			// load next number from memory and increment the pointer R3
			CMP R0, R1					// compare current and previous number (R1 is the new number and R0 is the current minimum)
			BLE SUBROUTINE				// if old value still greater, go back to SUBROUTINE (don't record it as the new minimum)
			MOV R0, R1					// if new value in R1 is greater, move value from R1 to R0 (there is a new minimum)
			B SUBROUTINE				// branch back to SUBROUTINE

END: 		B END						// infinite loop!
	
RESULT: 	.word	0					// memory assigned for result location
N:			.word	6					// number of entries in the list
NUMBERS:	.word	4, 5, 3, 10, -1, 5				// the list data

