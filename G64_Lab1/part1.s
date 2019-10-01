// This program finds the maximum number in a list of numbers
// ECSE 324 Group 64 Raymond Yang & Chang Zhou
// Date: 20190930
 			
			.text
			.global _start

_start:
			LDR R4, =RESULT				// R4 points to the memory location of RESULT
			LDR R2, [R4, #4]			// R2 holds the number of entries in the list
			ADD R3, R4, #8				// R3 points to address (R4 + 8 bytes), the first number in list
			LDR R0, [R3]				// R0 holds the first number in the list

LOOP: 		SUBS R2, R2, #1				// number of entries is decremented
			BEQ DONE					// goto DONE if counter has reached 0
			ADD R3, R3, #4				// R3 points to next number in list
			LDR R1, [R3]				// load next number from memory address stored in R3
			CMP R0, R1					// compare current and previous number
			BGE LOOP					// if old value still greater, go back to LOOP
			MOV R0, R1					// if new value in R1 is greater, move value from R1 to R0
			B LOOP						// branch back to LOOP

DONE: 		STR R0, [R4]				// in the end, store contents in R0 into memory location stored in R4 (allocated for result).

END: 		B END						// infinite loop!
	
RESULT: 	.word	0					// memory assigned for result location
N:			.word	7					// number of entries in the list
NUMBERS:	.word	4, 5, 3, 6			// the list data
			.word	1, 8, 2
