<<<<<<< HEAD
// This program finds the minimum element in a list of numbers and stores the result in R1
// Date: 20191018
// Author: Raymond Yang, Chang Zhou
=======
>>>>>>> 2ae03902a00ab0e1d423eec149c4d5a709c253ab
			.text
			.global _start

_start:
<<<<<<< HEAD
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
=======
			LDR R4, =RESULT				// R4 points to the memory location of RESULT
			LDR R2, [R4, #4]			// R2 holds the number of entries in the list
			ADD R3, R4, #8				// R3 points to address (R4 + 8 bytes), the first number in list
			LDR R0, [R3]				// R0 holds the first number in the list
			BL 	LOOP
			B	END

LOOP: 		SUBS R2, R2, #1				// number of entries is decremented
			BX	LR					// goto DONE if counter has reached 0
			ADD R3, R3, #4				// R3 points to next number in list
			LDR R1, [R3]				// load next number from memory address stored in R3
			CMP R0, R1					// compare current and previous number
			BLE LOOP					// if old value still greater, go back to LOOP
			MOV R0, R1					// if new value in R1 is greater, move value from R1 to R0
			B LOOP						// branch back to LOOP
>>>>>>> 2ae03902a00ab0e1d423eec149c4d5a709c253ab

END: 		B END						// infinite loop!
	
RESULT: 	.word	0					// memory assigned for result location
<<<<<<< HEAD
N:			.word	6					// number of entries in the list
NUMBERS:	.word	4, 5, 3, 10, -1, 5				// the list data
=======
N:			.word	3					// number of entries in the list
NUMBERS:	.word	4, 5, 3				// the list data
>>>>>>> 2ae03902a00ab0e1d423eec149c4d5a709c253ab

