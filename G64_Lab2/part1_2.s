// This program finds the minimum element in a list of 3 numbers
			.text
			.global _start

_start:
			MOV R0, #4					// If this was a subroutine, the input parameters would be loaded into R0, R1, and R2
			MOV R1, #5					// This part is used to allow us to test our subroutine
			MOV R2, #3					// The actual subroutine is labelled below
			BL 	SUBROUTINE				// call subroutine, link register stores address of next instruction
			B	END

// This part is the actual subroutine:
SUBROUTINE: 
			PUSH	{R4-LR}				// save state of R4-LR registers (convention) used here for demonstration but we don't really need since we are not using R4-LR
			CMP 	R0, R1				// compare first and second number (we plan to store result in R0)
			MOVGT 	R0, R1				// if R1 < R0, move R1 (new minimum) to R0 
			CMP 	R0, R2				// compare the third number with the current minimum
			MOVGT 	R0, R2				// if the third number is less than the current minimum, it is the new minimum
			POP		{R4-LR}				// restore state of R4-LR registers (convention)		
			BX		LR					// exit subroutine

END: 		B END						// infinite loop!

