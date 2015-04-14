;By Wes, Morgan, Ayne and Eric
; This is the test
	.ORIG x3000












START	LEA	R0,WelcomeMsg	; Intro message load
	PUTS			; output the message
LoopS
	GETC			; to input a number

	LD      R7,nl  		; check for new line char
	ADD     R7,R7,R0   	; end of line
	BRnp	LoopS
	OUT			;only if its a new line char
Term1	LEA	R0,AskTerm1	; the following signals

		PUTS		; the operator

	LEA	R1,TERM1

Loop1		GETC		; to input a number

    		OUT		; r0 to console
	STR	R0,R1,#0	; r0 to ( memory address stored in r1 + 0 )
    	ADD	R1,R1,#1	; increments the memory pointer so that it points to next available memory
	LD      R7,nl  		; check for new line char
	ADD     R7,R7,R0   	; end of line	
	BRnp	Loop1
;
; *** HERE IMPLEMENT SOME CHECKER TO MAKE SURE ONLY 3 NUMBERS entered AND A NEWLINE CHAR.
;
	LEA	R0,AskTerm2	; the following signals

		PUTS		; the operator
	LEA	R1,TERM2

Loop2		GETC		; to input a number

    		OUT		; r0 to console
	STR	R0,R1,#0	; r0 to ( memory address stored in r1 + 0 )
    	ADD	R1,R1,#1	; increments the memory pointer so that it points to next available memory
	LD      R7,nl  		; check for new line char
	ADD     R7,R7,R0   	; end of line	
	BRnp	Loop2
;
; *** HERE IMPLEMENT SOME CHECKER TO MAKE SURE ONLY 3 NUMBERS entered AND A NEWLINE CHAR.
;
	LEA	R0,AskOp
	PUTS
	GETC
	OUT
TestOp	LD	R1,PLUS
	ADD	R1,R1,R0	
	BRz	ADDITION	; if 0 then its addition
;
	LD	R1,MINUS
	ADD	R1,R1,R0	
	BRz	SUBTRACTION	; if 0 then its subtraction
;
	LD	R1,MULT
	ADD	R1,R1,R0	
	BRz	MULTIPLICATION	; if 0 then its multiplication
;
	LD	R1,DIVIDE
	ADD	R1,R1,R0
	BRz	DIVISION	; if 0 then its division
;
; *** HERE TRANSFORM THE CHARS TO BINARY NUMBERS
;	Will likely use this to be branched to (used like function on both terms)
;
	;toBin	LD	R2,TERM1
		;LD	R3,ASCIIMIN
		;ADD	R2,R2,R3
;	
; -------------- ARITHMATIC FUNCTIONS --------------
;using R2 and R3 as the operands, and putting answer in R2

;using R4 and R5 as registers where input was stored

;
ADDITION	LDR R2, R4, #0 ;get left hand operand
	 
		LDR R3, R5, #0	;get right hand operand
	 
		ADD R2, R2, R3	;add R2 + R3 and store in R2
	
		; *** branch back to the output section




;using R2 and R3 as the operands, and putting answer in R2

;using R4 and R5 as registers where input was stored



SUBTRACTION 	LDR R2, R4, #0 ;load lho
		LDR R3, R5, #0 ;load rho
		NOT R3, R3     ;make R3 negative

		ADD R2, R2, R3 ;add R2 + R3 and store in R2
		; *** branch back to output the answer

MULTIPLICATION	LDR R2, R4, #0 ;load lho
		LDR R3, R5, #0 ;load rho
		;do comparison and store smaller number in R6
		;store bigger number in R3	
		
MultLoop	;***BRz to output 
		ADD R2, R2, R3 ;add bigger number to itself
		ADD R6, R6, #-1 ;subtract counter
		BR MultLoop
		


DIVISION	LDR R2, R4, #0 ;load lho
		LDR R3, R5, #0 ;load rho
		LD  R6, #0 ;counter starts at Zero
		NOT R3, R3 ; make rho neg to subtract
DivLoop		ADD R2, R2, R3 ; subtract lho from rho
		ADD R6, R6, #1 ; increment counter
		BRzp DivLoop

		ADD R6, R6, #-1 ;decrement once to get correct answer
		;***Branch back to output. R6 will be the answer
		
; -------------- VARIABLES AND CONSTANTS --------------
Max	.FILL	x0003	; *** not cuurently used but will be used for checking only 3 digit ints used

WelcomeMsg	.STRINGZ	"Welcome to our supa simple calculata!"
AskTerm1	.STRINGZ	"Please Enter the first Term:"
AskTerm2	.STRINGZ	"Please Enter the second Term:"
AskOp		.STRINGZ	"What type of arithmetic would you like to do (+ - * /)?"

TERM1	.BLKW	4
TERM2	.BLKW	4
OP	.BLKW	1

nl	.FILL	xFFF6
PLUS	.FILL	xFFD5
MINUS	.FILL	xFFD3
MULT	.FILL	xFFD6
DIVIDE	.FILL	xFFD1
ASCIIMIN	.FILL	xFFE2

;Find10th	.FILL with numbers to calc to binary
;Find100th	.FILL with numbers to calc to binary

Done	HALT
.END





