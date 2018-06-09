LIB	SEGMENT 'CODE'
	ASSUME CS:LIB
	PUBLIC PRT_HX
;=================================================================
;Prints 16-bit number saved in DX, in hexadeximal form. Also works
;with negative numbers. Does NOT print a new line.
;=================================================================
PRT_HX	PROC	FAR
	PUSH CX
	PUSH BX
	ROL DX,1		;check sign
	JNC POS
	ROR DX,1		;fix
	NOT DX
	ADD DX,1		;two's complement
	MOV BX,DX		;save number
	MOV DL,2DH		;print neg sign
	MOV AH,02H
	INT 21H
BLOOPA:	MOV CL,04H		;loop counter
LOOPA:	MOV DX,BX		;retrieve number
	ROL DX,1		;ROL DX,4
	ROL DX,1
	ROL DX,1
	ROL DX,1
	MOV BX,DX		;save rotated number
	AND DX,000FH		;examine 4 bits
	CMP DL,09H
	JG BGG
	CMP CL,4		;it's not beautiful
	JL CEED			;to print zero
	CMP DL,00H		;as the first number
	JE NXT
CEED:	ADD DL,30H		;get ASCII code
BCK:	MOV AH,02H		;and print
	INT 21H
NXT:	DEC CL			;update counter
	JNZ LOOPA
	MOV DX,BX		;retrieve number
	POP BX
	POP CX
	RET
BGG:	ADD DL,37H
	JMP BCK
POS:	ROR DX,1		;fix number shifted because of
	MOV BX,DX		;sign check
	JMP BLOOPA
PRT_HX	ENDP
LIB	ENDS
	END
;================================================================
