// Computes term n of the fibonnacci sequence
// Date: 20191019
// Author: Raymond Yang
				.text
				.global _start

_start:
				LDR		R1, =N		// fibonnacci number
				LDR		R1, [R1]	// used for counter
				MOV		R0, R1		// R0 stores the result
				MOV		R2, #0		// R2 stores the n - 2 term
				MOV		R3, #1		// R3 stores the n - 1 term
				BL		FIBONNACCI	// go to subroutine 
				B		END			// computation finished
				
FIBONNACCI:						
				CMP		R1, #2		// if counter is below 2 then we can start adding
				BXLT	LR			// go back to calling instruction if R1 < 2 through the link register
				SUBS	R1, R1, #1	// decrement counter
				PUSH	{LR}		// push link register onto stack so it is not overwritten
				BL		FIBONNACCI	// call subroutine recursively
				POP		{LR}		// pop out link register to go back to upper level
				ADD		R0, R2, R3	// n = n - 1 + n - 2
				MOV		R2, R3		// update n - 2
				MOV		R3, R0		// update n - 1
				BX		LR			// branch back to upper level

END:			B 		END			// end

N:				.word	1			// the fibonacci sequence term