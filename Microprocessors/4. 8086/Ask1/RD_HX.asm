D_SEG	SEGMENT
BUFF	DB	2 DUP(?)
D_SEG	ENDS

LIB	SEGMENT 'CODE'
	ASSUME CS:LIB, DS:D_SEG
	PUBLIC RD_HX
;=================================================================
;Reads HEX number of up to 3 digits. Calculates actual numeric
;value, saved at DX. Finishes when a symbol is given, or when Q
;is pressed. Symbol ASCII code saved at AL.
;=================================================================
RD_HX	PROC 	FAR
	PUSH BX
	PUSH CX
	MOV CX,0		;digit counter
INPT:	CMP CX,03H		
	JGE GOUT
	MOV AH,07H		;read (no echo)
	INT 21H
	CMP AL,2BH		;'+' ?
	JE SYM
	CMP AL,2DH		;'-' ?
	JE SYM
	CMP AL,30H		;number?
	JL INPT			;invalid is only possibility
	CMP AL,39H
	JLE NUM
	CMP AL,3DH		;'=' ?
	JE SYM
CHK3:	CMP AL,41H		;letter?
	JL INPT
	CMP AL,46H
	JLE LETT
	CMP AL,51H		;'Q' ?
	JNE INPT		;not valid input. again
KILL:	MOV AH,4CH		;'Q' given -> stop program
	INT 21H	
LETT:	INC CX
	MOV DL,AL
	MOV AH,02H
	INT 21H
	SUB AL,37H		;get actual numeric value
	JMP FNSH
NUM:	MOV DL,AL
	MOV AH,02H
	INT 21H
	INC CX
	SUB AL,30H		;get actual numeric value
FNSH:	MOV AH,0		;zero-pad
	MOV BX,AX		;add last digit to result
	CMP CX,01H		;if this was first digit, result
	JG FCK			;is ready
	LEA BP,BUFF
	MOV [BP],AL		;update buffer
	MOV DX,BX
	JMP INPT		 
FCK:	CMP CX,02H
	JE GNEWS
BDNEWS:	LEA BP,BUFF
	MOV AL,[BP]
	MOV SI,10H
	MUL SI
	ADD BX,AX
	INC BP
	MOV AL,[BP]
	MOV SI,100H
	MUL SI
	ADD BX,AX
	MOV DX,BX 
	JMP GOUT		;no more digits to give!
GNEWS:	LEA BP,BUFF		;shift BUFF to the right
	MOV DL,[BP]
	MOV [BP],AL
	INC BP
	MOV [BP],DL
	MOV AL,DL
	MOV SI,10H
	MUL SI
	ADD BX,AX
	MOV DX,BX
	JMP INPT		;can press one more		
SYM:	CMP CL,00		;has there been at least one
	JE INPT			;digit?
GOUT:	POP CX
	POP BX
	RET
RD_HX	ENDP
LIB	ENDS
	END
;================================================================
