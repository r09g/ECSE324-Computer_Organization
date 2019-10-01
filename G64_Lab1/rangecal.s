// This program finds the range of 5 given numbers
// ECSE 324 Group 64 Raymond Yang & Chang Zhou
// Date: 20190930
 			
			.text
			.global _start

_start:
			LDR R0, =RESULT				// R0 holds the address of RESULT
			LDR R1, [R0, #4]			// R1 holds the number of entries in the list
			ADD R2, R0, #8				// R2 holds the address of the first number in the list
										// since the contents of R0 is the address of RESULT
			LDR R3, [R2]				// R3 stores max
			LDR R4, [R2]				// used to store min

LOOP: 		SUBS R1, R1, #1				// number of entries is decremented
			BEQ DONE					// goto DONE if counter has reached 0
			ADD R2, R2, #4				// Update R2 (address of next number in list)
			LDR R5, [R2]				// load next number from memory address stored in R2 into R5
			CMP R5, R3					// compare maximum and next number
			BGE TAKEMAX					// if new number is greater than old number, record new max
			B CMPMIN					// if not a max, go on to check if it is a min

CMPMIN:		CMP R5, R4					// compare minimum with next number
			BLE TAKEMIN					// if not a new  minimum continue to LOOP
			B LOOP						// branch back to LOOP

TAKEMAX:	MOV R3, R5					// record new max value
			B CMPMIN					// continue to compare minimum

TAKEMIN: 	MOV R4, R5					// record new min value
			B LOOP						// continue loop

DONE: 		SUBS R3, R3, R4				// calculate difference between max and min and store in R3
			STR R3, [R0]				// store calculated range in RESULT (whose addressed is stored as the content of R0)

END: 		B END						// infinite loop!
	
RESULT: 	.word	0					// memory assigned for result location
N:			.word	5					// number of entries in the list
NUMBERS:	.word	4, 5, 3, 6, 9			// the list data
