; Created by: Ayne Delgado, Westley Case, Morgan Allred, Eric Van Wagner
	.ORIG x3000
	AND R0, R0, #0
	AND R1, R1, #0
	AND R2, R2, #0
	AND R3, R3, #0
	AND R4, R4, #0
	AND R5, R5, #0
	AND R6, R6, #0
	AND R7, R7, #0

	LEA R0, Welcome ;welcome message
		PUTS
	LD R0, NewlineChar
	OUT

Welcome		.STRINGZ	"Welcome to the Supa Simple Calculata! "



Term1	LEA	R0,AskTerm1	; the following signals

		PUTS			; the operator

	LEA	R1,TERM1
	JSR	Loop1

Break1  LEA       R2,TERM1
	NOT       R2,R2
        ADD       R2,R2,#1
        ADD       R1,R1,R2      ; R1 now contains no. of char.

	JSR	ASCIItoBinary
;
	ADD	R6,R0,#0
;-------------------------
Term2	LEA	R0,AskTerm2	; the following signals

		PUTS			; the operator

	LEA	R1,TERM1
	JSR	Loop2

Break2	LEA       R3,TERM1
	NOT       R3,R3
        ADD       R3,R3,#1
        ADD       R1,R1,R3      ; R1 now contains no. of char.
	
	JSR	ASCIItoBinary
	ADD	R3,R0,#0
	
	ADD	R2,R6,#0	;Our ghettto fix

	LEA	R0,AskOp
	PUTS
	GETC
	OUT

TERM1		.BLKW		4
	

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

PLUS	.FILL	xFFD5
MINUS	.FILL	xFFD3
MULT	.FILL	xFFD6
DIVIDE	.FILL	xFFD1

OUTPUT	JSR BinarytoASCII
	LD R0, NewlineChar
	OUT
	LEA R0,ASCIIBUFF
	PUTS

	HALT
Loop1		GETC		; to input a number

    		OUT		; r0 to console
		LD      R7,nl  		; check for new line char
		ADD     R7,R7,R0   	; end of line	
		BRz	Break1
		STR	R0,R1,#0	; r0 to ( memory address stored in r1 + 0 )
    		ADD	R1,R1,#1	; increments the memory pointer so that it points to next available memory
		BRnp	Loop1

Loop2		GETC		; to input a number

    		OUT		; r0 to console
		LD      R7,nl  		; check for new line char
		ADD     R7,R7,R0   	; end of line	
		BRz	Break2
		STR	R0,R1,#0	; r0 to ( memory address stored in r1 + 0 )
    		ADD	R1,R1,#1	; increments the memory pointer so that it points to next available memory
		BRnp	Loop2

ASCIItoBinary  AND    R0,R0,#0      ; R0 will be used for our result 
               ADD    R1,R1,#0      ; Test number of digits.
               BRz    Return		    ; There are no digits
;
               LD     R3,NegASCIIOffset  ; R3 gets xFFD0, i.e., -x0030
               LEA    R2,TERM1
               ADD    R2,R2,R1
               ADD    R2,R2,#-1     ; R2 now points to "ones" digit
;              
               LDR    R4,R2,#0      ; R4 <-- "ones" digit
               ADD    R4,R4,R3      ; Strip off the ASCII template
               ADD    R0,R0,R4      ; Add ones contribution
;
               ADD    R1,R1,#-1
               BRz    Return		    ; The original number had one digit
               ADD    R2,R2,#-1     ; R2  now points to "tens" digit
;
               LDR    R4,R2,#0      ; R4 <-- "tens" digit
               ADD    R4,R4,R3      ; Strip off ASCII  template
               LEA    R5,LookUp10   ; LookUp10 is BASE of tens values
               ADD    R5,R5,R4      ; R5 points to the right tens value
               LDR    R4,R5,#0
               ADD    R0,R0,R4      ; Add tens contribution to total
;
               ADD    R1,R1,#-1
               BRz    Return	; The original number had two digits
               ADD    R2,R2,#-1     ; R2 now points to "hundreds" digit
;        
               LDR    R4,R2,#0      ; R4 <-- "hundreds" digit
               ADD    R4,R4,R3      ; Strip off ASCII template
               LEA    R5,LookUp100  ; LookUp100 is hundreds BASE
               ADD    R5,R5,R4      ; R5 points to hundreds value
               LDR    R4,R5,#0
               ADD    R0,R0,R4      ; Add hundreds contribution to total
Return		RET
;  




;r2 and r3 will have the operands
;r0 will hold the answer
ADDITION ADD R0, R2, R3	;add R2 + R3 and store in R2
BRnzp OUTPUT

SUBTRACTION NOT R3, R3
ADD R3, R3, #1
ADD R0, R2, R3
BRnzp OUTPUT


MULTIPLICATION AND R4, R4, #0
AND R5, R5, #0
ADD R4, R2, #0 ;r4 holds r2
ADD R5, R3, #0 ;r5 holds R3
NOT R5, R5
ADD R5, R5, #1 ; NOT rho
ADD R4, R4, R5
Brzp Multiply
Swap ADD R6, R2, #0
AND R2, R2, #0
ADD R2, R3, #0
AND R3, R3, #0
ADD R3, R6, #0
Multiply AND R0, R0, #0
MultLoop ADD R0, R0, R2
ADD R3, R3, #-1
BRp MultLoop
Brnzp OUTPUT


DIVISION AND R6, R6, #0 ;counter
NOT R3, R3
ADD R3, R3, #1
DivLoop ADD R6, R6, #1
ADD R2, R2, R3
BRp DivLoop
ADD R0, R6, #0
BRnzp OUTPUT
;
; This algorithm takes the 2's complement representation of a signed
; integer, within the range -999 to +999, and converts it into an ASCII
; string consisting of a sign digit, followed by three decimal digits.
; R0 contains the initial value being converted.
;
BinarytoASCII LEA R1,ASCIIBUFF ; R1 points to string being generated
	ADD R0,R0,#0 	; R0 contains the binary value
	BRn NegSign 	;
	LD R2,ASCIIplus ; First store the ASCII plus sign
	STR R2,R1,#0
	BRnzp Begin100
NegSign LD R2,ASCIIminus ; First store ASCII minus sign
	STR R2,R1,#0
	NOT R0,R0 ; Convert the number to absolute
	ADD R0,R0,#1 ; value; it is easier to work with.
;
Begin100 LD R2,ASCIIoffset ; Prepare for "hundreds" digit
;
	LD R3,Neg100 ; Determine the hundreds digit
	Loop100 ADD R0,R0,R3
	BRn End100
	ADD R2,R2,#1
	BRnzp Loop100
;
End100 	STR R2,R1,#1 ; Store ASCII code for hundreds digit
	LD R3,Pos100
	ADD R0,R0,R3 ; Correct R0 for one-too-many subtracts
;
LD R2,ASCIIoffset ; Prepare for "tens" digit
;
Begin10 LD R3,Neg10 ; Determine the tens digit
Loop10 ADD R0,R0,R3
BRn End10
ADD R2,R2,#1
BRnzp Loop10
;
End10 STR R2,R1,#2 ; Store ASCII code for tens digit
ADD R0,R0,#10 ; Correct R0 for one-too-many subtracts
Begin1 LD R2,ASCIIoffset ; Prepare for "ones" digit
ADD R2,R2,R0
STR R2,R1,#3
RET
;
ASCIIBUFF .BLKW 5 
ASCIIplus .FILL x002B
ASCIIminus .FILL x002D
ASCIIoffset .FILL x0030
Neg100 .FILL xFF9C
Pos100 .FILL x0064
Neg10 .FILL xFFF6
NewlineChar .FILL x000A
NegASCIIOffset .FILL  xFFD0

LookUp10       .FILL  #0
               .FILL  #10
               .FILL  #20
               .FILL  #30
               .FILL  #40
               .FILL  #50
               .FILL  #60
               .FILL  #70
               .FILL  #80
               .FILL  #90
;
LookUp100      .FILL  #0
               .FILL  #100
               .FILL  #200
               .FILL  #300
               .FILL  #400
               .FILL  #500
               .FILL  #600
               .FILL  #700
               .FILL  #800
               .FILL  #900

;--------------- const for ascii to bin -----------

AskTerm1	.STRINGZ	"Enter a number (3 digits max): "
AskTerm2	.STRINGZ	"Next number: "
AskOp		.STRINGZ	"What type of arithmetic would you like to do (+ - * /)?"

nl		.FILL		xFFF6


.END