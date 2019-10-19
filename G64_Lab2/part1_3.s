// This program computes the factorial of a number
// Date: 20191018
// Author: Raymond Yang, Chang Zhou

			.text
			.global _start

_start:
			LDR R0, =RESULT				// R0 points to the memory location of RESULT
			LDR R1, [R0, #4]			// R1 holds the number to be factorial
			// Check if the number is 0, if 0 then return 1
			TEQ R1, #0					// check if input is 0
			MOVEQ R2, #1				// if input is 0 then just return 1
			BEQ DONE					// if input is 0 then do not need to compute factorial
			// if number is not 0 then call factorial subroutine
			MOV R2, R1					// The number N is stored in R2 (holds the result)
			BL FACTORIAL				// Call factorial
			B DONE						// computation done

FACTORIAL: 
			SUBS R1, R1, #1				// decrement the number of elements to keep track of factorial operation
			BXEQ LR						// if n = 0, then we are done with factorial and just return 
			MUL R2, R2, R1				// if n is not 0 yet, multiply current number by number - 1
			PUSH {LR}					// save current link register by pushing into stack
			BL FACTORIAL				// recursively call factorial again
			POP {LR}					// when each layer of factorial returns, pop out LR from stack to return
			BX LR						// go back to the calling instruction

DONE:		STR R2,[R0]					// store result in memory

END: 		B END						// infinite loop!
	
RESULT: 	.word	0					// memory assigned for result location
N:			.word	3					// number of entries in the list


