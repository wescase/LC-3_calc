;By Wes, Morgan, Ayne and Eric
; This is the test
.ORIG x3000











;using R2 and R3 as the operands, and putting answer in R2
;using R4 and R5 as registers where input was stored

ADDITION LDR R2, R4, #0 ;get left hand operand
	 LDR R3, R5, #0	;get right hand operand
	 ADD R2, R2, R3	;add R2 + R3 and store in R2
	;branch back to the output section


;using R2 and R3 as the operands, and putting answer in R2
;using R4 and R5 as registers where input was stored

SUBTRACTION LDR R2, R4, #0 ;load lho
	    LDR R3, R5, #0 ;load rho
	    NOT R3, R3     ;make R3 negative
	    ADD R2, R2, R3 ;add R2 + R3 and store in R2
	    ;branch back to output the answer

.END





