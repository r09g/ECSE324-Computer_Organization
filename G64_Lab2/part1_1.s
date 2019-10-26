// This program demonstrates the PUSH and POP operation in ARM ASM
// Date: 20191018
// Author: Raymond Yang, Chang Zhou

					.text
					.global _start

_start:
				MOV		R0, #2				// load number 2 into R0
				PUSH	{R0}				// push value of R0 onto stack. SP is decremented first, value of R0 is stored in the memory location SP is pointing to
				MOV		R0, #3				// load number 3 into R0
				PUSH	{R0}				// push value of R0 onto stack. SP is decremented first, value of R0 is stored in the memory location SP is pointing to
				MOV		R0, #4				// load number 4 into R0
				PUSH	{R0}				// push value of R0 onto stack. SP is decremented first, value of R0 is stored in the memory location SP is pointing to
				POP		{R1}				// pop stack to retrieve value and store in R2, R3, and R4
				POP		{R2}				// stack structure is FIFO.
				POP		{R3}				// In this case we expect R1 = 4, R2 = 3, and R3 = 2

END:			B END						// end program by keeping it in infinite loop

NUMBERS:		.word	1, 2, 3

