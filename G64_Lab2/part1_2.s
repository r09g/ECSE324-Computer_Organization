			.text
			.global _start

_start:
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

END: 		B END						// infinite loop!
	
RESULT: 	.word	0					// memory assigned for result location
N:			.word	3					// number of entries in the list
NUMBERS:	.word	4, 5, 3				// the list data

