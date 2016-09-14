;Assuming user will only enter ' ' 0-9 *+/-
;
;
;
.ORIG x3000
	
;your code goes here
	



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;R3- value to print in hexadecimal
PRINT_HEX

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;R0 - character input from keyboard
;R6 - current numerical output
;
;
EVALUATE

;your code goes here


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0
PLUS	
;your code goes here
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0
MIN	
;your code goes here
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0
MUL
;your code goes here
	ST R3, MUL_SaveR3	;save R3
	ST R4, MUL_SaveR4	;save R4
	ST R7, MUL_SaveR4	;save R7
JSR POP
AND R3, R3, 0 ;	init R3
ADD R3, R0, R3 ; get first operand
JSR POP
AND R4, R4, 0 ; init R4
ADD R4, R0, R4 ; get second operand
MULTLOOP	ADD R3, R3, R3 ; add R3 to itself
		ADD R4, R4, -1 ; R4--
		BRp MULTLOOP
		AND R0, R0, 0 ; clear R0
		ADD R0, R0, R3 ; put output in R0
		LD R3, MUL_SaveR3
		LD R4, MUL_SaveR4
		LD R7, MUL_SaveR7
		RET

MUL_SaveR3	.BLKW #1
MUL_SaveR4	.BLKW #1
MUL_SaveR7	.BLKW #1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0
;DIV	
;your code goes here
	ST R3, DIV_SaveR3
	ST R4, DIV_SaveR4
	ST R7, DIV_SaveR7
	JSR POP
	AND R3, R3, 0 ;	init R3
	ADD R3, R0, R3 ; get first operand
	JSR POP
	AND R4, R4, 0 ; init R4
	ADD R4, R0, R4 ; get second operand
	AND R0, R0, 0  ; clear R0
	NOT R4, R4 
	ADD R4, R4, 1  ; get inverse of R4
DIVLOOP	ADD R3, R3, R4 ; subtract R4 from R3
	ADD R0, R0, 1  
	AND R3. R3. R3
	BRp DIVLOOP
	LD R3, DIV_SaveR3
	LD R4, DIV_SaveR4
	LD R7, DIV_SaveR7
	RET

DIV_SaveR3	.BLKW #1
DIV_SaveR4	.BLKW #1
DIV_SaveR7	.BLKW #1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0
;EXP
;your code goes here
	
;IN:R0, OUT:R5 (0-success, 1-fail/overflow)
;R3: STACK_END R4: STACK_TOP
;
PUSH	
	ST R3, PUSH_SaveR3	;save R3
	ST R4, PUSH_SaveR4	;save R4
	AND R5, R5, #0		;
	LD R3, STACK_END	;
	LD R4, STACk_TOP	;
	ADD R3, R3, #-1		;
	NOT R3, R3		;
	ADD R3, R3, #1		;
	ADD R3, R3, R4		;
	BRz OVERFLOW		;stack is full
	STR R0, R4, #0		;no overflow, store value in the stack
	ADD R4, R4, #-1		;move top of the stack
	ST R4, STACK_TOP	;store top of stack pointer
	BRnzp DONE_PUSH		;
OVERFLOW
	ADD R5, R5, #1		;
DONE_PUSH
	LD R3, PUSH_SaveR3	;
	LD R4, PUSH_SaveR4	;
	RET


PUSH_SaveR3	.BLKW #1	;
PUSH_SaveR4	.BLKW #1	;


;OUT: R0, OUT R5 (0-success, 1-fail/underflow)
;R3 STACK_START R4 STACK_TOP
;
POP	
	ST R3, POP_SaveR3	;save R3
	ST R4, POP_SaveR4	;save R3
	AND R5, R5, #0		;clear R5
	LD R3, STACK_START	;
	LD R4, STACK_TOP	;
	NOT R3, R3		;
	ADD R3, R3, #1		;
	ADD R3, R3, R4		;
	BRz UNDERFLOW		;
	ADD R4, R4, #1		;
	LDR R0, R4, #0		;
	ST R4, STACK_TOP	;
	BRnzp DONE_POP		;
UNDERFLOW
	ADD R5, R5, #1		;
DONE_POP
	LD R3, POP_SaveR3	;
	LD R4, POP_SaveR4	;
	RET


POP_SaveR3	.BLKW #1	;
POP_SaveR4	.BLKW #1	;
STACK_END	.FILL x3FF0	;
STACK_START	.FILL x4000	;
STACK_TOP	.FILL x4000	;


.END
