;Assuming user will only enter ' ' 0-9 *+/-
;
;
;
.ORIG x3000
	
;your code goes here
	

GET_CHAR
	AND R0, R0, 0
	GETC ; get input from the user
	OUT ; echo
	LD R1, SPACE
	NOT R1, R1
	ADD R1, R1, 1 ; basically multiplies R1 by -1
	ADD R1, R0, R1 ; 
	BRz GET_CHAR ; if space

	; check operators
	LD R1, PLUSSIGN
	NOT R1, R1
	ADD R1, R1, 1 ; basically multiplies R1 by -1
	ADD R1, R0, R1 ; 
	JSR PLUS

	LD R1, MINUSSIGN
	NOT R1, R1
	ADD R1, R1, 1 ; basically multiplies R1 by -1
	ADD R1, R0, R1 ; 
	JSR MIN

	LD R1, MULTSIGN
	NOT R1, R1
	ADD R1, R1, 1 ; basically multiplies R1 by -1
	ADD R1, R0, R1 ; 
	JSR MUL

	LD R1, DIVSIGN
	NOT R1, R1
	ADD R1, R1, 1 ; basically multiplies R1 by -1
	ADD R1, R0, R1 ; 
	JSR DIV
	
	LD R1, POWSIGN
	NOT R1, R1
	ADD R1, R1, 1 ; basically multiplies R1 by -1
	ADD R1, R0, R1 ; 
	JSR EXP

	; check to see if num
	AND R1, R1, 0 ; clear R1
	ADD R1, R1, #-12
	ADD R1, R1, #-12
	ADD R1, R1, #-12
	ADD R1, R1, #-12
	ADD R1, R0, R1
	BRn INVALID	; if ascii val is less than 48, it is invalid
	AND R1, R1, 0
	ADD R1, R1, #-11
	ADD R1, R1, #-11
	ADD R1, R1, #-11
	ADD R1, R1, #-11
	ADD R1, R1, #-13
	ADD R1, R0, R1
	BRnz ISNUM ; if satisfies both, then it is a num
	BRnzp INVALID ; if anything else, it is invalid
	; end num check

ISNUM	JSR PUSH
	BRnzp GET_CHAR
	
;check to see if operand or operator
;if operator, then push to stack
; ascii numbers: 48-57
; ascii operators: 42*  43+   45-   94^




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;R3- value to print in hexadecimal
PRINT_HEX

;R1 acts as the digit counter (4 digits inside R3)
;R2 acts as the bit counter (4 bits per digit)
AND R3, R3, 0
ADD R3, R3, R0 ; put R0 into R3
AND R1, R1, 0  ; initialize R1, clear and set to 4
ADD R1, R1, #4

OUTER	AND R2, R2, 0  ; initialize R2, clear and set to 4
	ADD R2, R2, #4
	AND R0, R0, 0  ; make sure to clear R0
	
	
LOOP	ADD R3, R3, 0 ; select R3
	BRzp POS
 NEG	ADD R4, R4, R4 ; r4 = r4 + r4 //shift left
	ADD R4, R4, #1   ; r4++
	ADD R3, R3, R3 ; r3 = r3 + r3 //shift left
	ADD R2, R2, #-1 ; r2--
	BRp LOOP  ; if r2 is still positive, go back to loop
	BRnzp ARFIVE

POS	ADD R4, R4, R4 ; r4 = r4 + r4
	ADD R3, R3, R3 ; r3 = r3 + r3 //shift left
ADD R2, R2, #-1 ; r2--
	BRp LOOP 

ARFIVE	AND R5, R5, 0 ; initialize R5
ADD R5, R5, R4 ;copy R4 into R5
ADD R5, R5, #-9 ; subtract R5 by 9
BRp  FIFTYFIVE ; if positive, then ALPHA --- if negative, them NUM
ADD R4, R4, #12
ADD R4, R4, #12
ADD R4, R4, #12
ADD R4, R4, #12 ;by this point, R4 should be fully converted
BRnzp PRINT

FIFTYFIVE	ADD R4, R4, #11
		ADD R4, R4, #11
		ADD R4, R4, #11
		ADD R4, R4, #11
		ADD R4, R4, #11 ;by this point, R4 should be fully converted
		BRnzp PRINT

PRINT	ADD R0, R0, R4 ;copy R4 into R0
AND R4, R4, 0 ; clear R4
TRAP x21
ADD R1, R1, #-1
BRp OUTER




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;R0 - character input from keyboard
;R5 - current numerical output
;
;
EVALUATE

;your code goes here


INVALID	AND R0, R0, 0
	LEA R0, INV_EX
	OUT
	HALT


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0
PLUS	
;your code goes here
	ST R3, PLUS_SaveR3
	ST R4, PLUS_SaveR4
	ST R7, PLUS_SaveR7
JSR POP
AND R3, R3, 0 ;	init R3
ADD R3, R0, R3 ; get first operand
JSR POP
AND R4, R4, 0 ; init R4
ADD R4, R0, R4 ; get second operand
AND R0, R0, 0 ; clear R0
ADD R0, R3, R4
	LD R3, PLUS_SaveR3
	LD R4, PLUS_SaveR4
	LD R7, PLUS_SaveR7

PLUS_SaveR3	.BLKW #1
PLUS_SaveR4	.BLKW #1
PLUS_SaveR7	.BLKW #1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0
MIN	
;your code goes here
	ST R3, MIN_SaveR3
	ST R4, MIN_SaveR4
	ST R7, MIN_SaveR7
JSR POP
AND R3, R3, 0 ;	init R3
ADD R3, R0, R3 ; get first operand
JSR POP
AND R4, R4, 0 ; init R4
ADD R4, R0, R4 ; get second operand
AND R0, R0, 0 ; clear R0
NOT R4, R4
ADD R4, R4, 1 ; get negative R4
ADD R0, R3, R4 ; 
	LD R3, MIN_SaveR3
	LD R4, MIN_SaveR4
	LD R7, MIN_SaveR7
RET

MIN_SaveR3	.BLKW #1
MIN_SaveR4	.BLKW #1
MIN_SaveR7	.BLKW #1	
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
DIV	
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
	ADD R0, R0, -1 ; set R0 to -1
	NOT R4, R4 
	ADD R4, R4, 1  ; get inverse of R4
DIVLOOP	ADD R3, R3, R4 ; subtract R4 from R3
	ADD R0, R0, 1  
	AND R3, R3, R3
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
EXP
;your code goes here

	ST R3, EXP_SaveR3
	ST R4, EXP_SaveR4
	ST R7, EXP_SaveR7
	JSR POP
	AND R3, R3, 0 ;	init R3
	ADD R3, R0, R3 ; get first operand
	JSR POP
	AND R4, R4, 0 ; init R4
	ADD R4, R0, R4 ; get second operand

AND R0, R0, 0
AND R1, R1, 0
AND R2, R2, 0
ADD R4, R4, 0
BRz ZEROPOW ; if R4 (power) is zero

INNERLOOP	ADD R1, R1, R3 ; set R1 to R3
		ADD R5, R5, R3 ; R5 will be product
		ADD R1, R1, -1 ; decrement R1
		BRp INNERLOOP
OUTERLOOP	AND R0, R0, R5 
		ADD R2, R2, -1
		BRp OUTERLOOP
		BRnzp FINISH

ZEROPOW	AND R0, R0, 0
	ADD R0, R0, 1

FINISH	RET

EXP_SaveR3	.BLKW #1
EXP_SaveR4	.BLKW #1
EXP_SaveR7	.BLKW #1
	
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
SPACE		.FILL x0020
PLUSSIGN	.FILL x002B
MINUSSIGN	.FILL x002D
MULTSIGN	.FILL x002A
DIVSIGN		.FILL x002F
POWSIGN		.FILL x005E

INV_EX		.STRINGZ "Invalid Expression."



.END
