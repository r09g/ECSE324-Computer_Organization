					.text
					.global _start

_start:
				LDR		R0, =NUMBERS		// address of the first number, load int
				LDMIA	R0, {R1,R2,R3}		
				STMFD	SP!,{R1,R2,R3}		

				LDMFD	SP!,{R3,R2,R1}		

END:			B END

NUMBERS:		.word	1, 2, 3

