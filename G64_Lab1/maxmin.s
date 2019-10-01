// This program finds max and min of the arithmetic operation (x1 + x2)*(y1 + y2)
// ECSE 324 Group 64 Raymond Yang & Chang Zhou
// Date: 20190930
 			
			.text
			.global _start

_start:
			LDR R0, =NUMBERS			// R0 points to the address of the first number
			LDR R1, [R0]				// R1 holds the first number
 			LDR R2, [R0, #4]			// R2 holds the second number
			LDR R3, [R0, #8]			// R3 holds the third number
			LDR R4, [R0, #12]			// R4 holds the fourth number
			ADD R5, R1, R2				// R5 holds the sum of Num1 and Num2
			ADD R6, R3, R4				// R6 holds sum of Num3 and Num4
			MUL R5, R5, R6				// R5 is (Num1+Num2)*(Num3+Num4)
			ADD R6, R1, R3				// R6 holds sum of Num1 and Num3
			ADD R7, R2, R4				// R7 holds sum of Num2 and Num4
			MUL R6, R6, R7				// R6 is (Num1+Num3)*(Num2+Num4)
			ADD R7, R1, R4				// R7 holds sum of Num1 and Num4
			ADD R8, R2, R3				// R8 holds sum of Num2 and Num3
			MUL R7, R7, R8				// R7 is (Num1+Num4)*(Num2+Num3)
			// we want R1 to store max and R2 to store min
			CMP R5, R6					// compare first 2 arithmetic results
			MOVLT R1, R6				// R6 is max if R5 < R6
			MOVLT R2, R5				// R5 is min if R5 < R6
			MOVGE R1, R5				// R5 is max if R5 >= R6
			MOVGE R2, R6				// R6 is min if R5 >= R6
			CMP R7, R1					// compare the third result with the maximum
			MOVGT R1, R7				// R7 is max if R7 > R1
			BGE DONE					// if R7 >= the max then max and min is found; if not, then need to compare with min to find minimum
			CMP R7, R2					// compare the third result with minimum
			MOVLT R2, R7				// if R7 < R2, then R7 is the new minimum
			B DONE						// go to DONE since max and min are found
			
DONE:		STR R2, [R0, #20]			// R2 is minimum
			STR R1, [R0, #16]			// R1 is maximum

END: 		B END						// infinite loop!
	
NUMBERS:	.word	1, 2, 3, 4			// the list data
MAX:	 	.word	0					// memory assigned for storing max value
MIN:		.word	0					// memory stored for stroing min value
