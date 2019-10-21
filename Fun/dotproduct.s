// This program computes the vector dot product
				.text
				.global _start

_start:
				LDR		R1, =N
				LDR		R1, [R1]
				LDR		R2, =VECA
				LDR		R3, =VECB
				LDR		R4, [R2]
				LDR		R5, [R3]
				MUL		R0, R4, R5		

LOOP:			SUBS	R1, R1, #1
				BEQ		END
				LDR		R4, [R2, #4]!
				LDR		R5, [R3, #4]!
				MLA		R0, R4, R5, R0
				B		LOOP


END:			B		END
N:				.word	2		// number of elements in vector
VECA:			.word	1,2
VECB:			.word	1,2


