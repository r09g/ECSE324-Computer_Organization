<<<<<<< HEAD
// This program demonstrates the PUSH and POP operation in ARM ASM
// Date: 20191018
// Author: Raymond Yang, Chang Zhou
=======
>>>>>>> 2ae03902a00ab0e1d423eec149c4d5a709c253ab
					.text
					.global _start

_start:
<<<<<<< HEAD
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

=======
				LDR		R0, =NUMBERS		// address of the first number, load int
				LDMIA	R0, {R1,R2,R3}		
				STMFD	SP!,{R1,R2,R3}		

				LDMFD	SP!,{R3,R2,R1}		

END:			B END

NUMBERS:		.word	1, 2, 3
>>>>>>> 2ae03902a00ab0e1d423eec149c4d5a709c253ab

