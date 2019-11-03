	.text 
	// address of timers
	.equ TIMER0, 0xFFC08000		
	.equ TIMER1, 0xFFC09000
	.equ TIMER2, 0xFFD00000
	.equ TIMER3, 0xFFD01000
	.global HPS_TIM_config_ASM
	.global HPS_TIM_read_INT_ASM
	.global HPS_TIM_clear_INT_ASM

HPS_TIM_config_ASM:	// configures a timer
	PUSH {R4-R6}				// save states (convention)
	LDR R1, [R0]				// load one-hot encoding of timers from struct pointer
	AND R1, R1, #0b1111			// extract only lowest 4 bits
	MOV R2, #0				// loop counter		
	B HPS_TIM_config_ASM_LOOP

HPS_TIM_config_ASM_LOOP:

	CMP R2, #4				// only 4 timers available
	POPGE {R4-R6}					
	BGE DONE					
	ANDS R3, R1, #1				// check if lowest bit is 1 to know whether timer is selected
	ASR R1, R1, #1				// shift timer bits by 1 to check the next timer
	ADDEQ R2, R2, #1			// increase counter
	BEQ HPS_TIM_config_ASM_LOOP		// if 0 then the current timer is not selected, check the next one

	// determine which timer is selected based on the current counter value
	CMP R2, #0				// BIT 0 IS 1
	LDREQ R4, =TIMER0			// load address of timer0
	CMP R2, #1				// BIT 1 IS 1
	LDREQ R4, =TIMER1			// load address of timer1
	CMP R2, #2				// BIT 2 IS 1
	LDREQ R4, =TIMER2			// load address of timer2
	CMP R2, #3				// BIT 3 IS 1
	LDREQ R4, =TIMER3			// load address of timer3


	//START CONFIGURATION
	LDR R5, [R4, #0x8]			// SET ENABLE TO 0 WHILE KEEP OTHER BIT UNCHANGED
	BIC R5, R5, #0b1			// enable is the LSB in this case			
	STR R5, [R4, #0x8] 			
	
	// for the first 2 timers, they have clock rate 100 MHz
	// for the 3rd and 4th timers, they have clock rate 25 MHz
	// timeout expressed in us, so 1us would mean 100 clock cycles
	LDR R5, [R0, #0x4]			//LOAD TIMEOUT from input
	CMP R2, #2				// determine which timer is selected so appropriate timeout can be configured
	MOVLT R6, #100				// The 100MHz timers are selected
	MOVGE R6, #25				// The 25MHz timers are selected
	MUL R5, R5, R6				// scale the timeout to match the number of clock period
	STR R5, [R4] 				//SET TIMEOUT to register

	LDR R5, [R0, #0x8]			// LOAD "LD_en"
	AND R5, R5, #0b1			// clear unwanted bits
	LSL R5, R5, #1				// M: start counting down from timeout

	LDR R3, [R0, #0xC]			// LOAD "INT_en"
	MVN R3, R3				// take complement since it is active-low
	AND R3, R3, #0b1			// clear any unwanted bits (retain only the LSB)
	LSL R3, R3, #2				// move to correct bit location
	ORR R5, R3, R5				// combine with previous instruction so that the instruction can be written into control register together

	LDR R3, [R0, #0x10]			// LOAD "enable"
	AND R3, R3, #0b1			// clear any unwanted bits
	ORR R5, R3, R5				// add into previous instruction
	
	STR R5, [R4, #0x8]			// STORE INTO CONTROL REGISTER

	ADD R2, R2, #1				// increment counter
	B HPS_TIM_config_ASM_LOOP


HPS_TIM_read_INT_ASM:	// read only one timer at a time

	PUSH {R4-R5}				//PUSH 
	// check which timer is selected and load the appropriate address of the timer
	CMP R0, #1
	LDREQ R1, =TIMER0			
	CMP R0, #2
	LDREQ R1, =TIMER1				
	CMP R0, #4
	LDREQ R1, =TIMER2			
	CMP R0, #8
	LDREQ R1, =TIMER3			

	LDR R2, [R1, #0x10]	// read the S bit from the timer
	AND R0, R2, #0b1	// take only the lowest bit
	
	POP {R4-R5}
	B DONE

HPS_TIM_clear_INT_ASM:	// clear interrupt registers of timers
	MOV R1, #0			// R1 = 0
	AND R0, R0, #0b1111		// only need lowest 4 bits		

CLEAR_INT_LOOP:
	CMP R1, #4			// only 4 timers
	BXEQ LR
	ANDS R2, R0, #1			// check if lowest bit is 1 to see if current timer is selected
	ASR R0, R0, #1			// rotate R0 1 bit right to check for next timer
	ADDEQ R1, R1, #1		// increment bit location
	BEQ CLEAR_INT_LOOP
	
	CMP R1, #0			//BIT 0 IS 1
	LDREQ R3, =TIMER0		//LOAD ADDRESS OF THE TIMER0
	CMP R1, #1			//BIT 1 IS 1
	LDREQ R3, =TIMER1		//LOAD ADDRESS OF THE TIMER1
	CMP R1, #2			//BIT 2 IS 1
	LDREQ R3, =TIMER2		//LOAD ADDRESS OF THE TIMER2
	CMP R1, #3			//BIT 3 IS 1
	LDREQ R3, =TIMER3		//LOAD ADDRESS OF THE TIMER3
	
	LDR R3, [R3, #0xC]		// reading the F bit will clear both F and S bits
	
	ADD R1, R1, #1			// increment counter
	B CLEAR_INT_LOOP

DONE:
	BX LR
	.end
