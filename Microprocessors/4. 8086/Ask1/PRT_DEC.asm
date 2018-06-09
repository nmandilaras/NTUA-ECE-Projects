LIB	SEGMENT 'CODE'
	ASSUME CS:LIB
	PUBLIC PRT_DEC
;=================================================================
;Prints 16-bit number saved in DX, in decimal form. Also works
;with negative numbers. Does NOT print a new line.
;=================================================================
PRT_DEC	PROC	FAR
	PUSH BX
	PUSH CX
	MOV BP,DX
	ROL DX,1		;check sign
	JNC POSI
	ROR DX,1		;fix
	NOT DX
	ADD DX,1		;two's complement
	MOV BX,DX
	MOV DL,2DH		;print neg sign
	MOV AH,02H
	INT 21H
	MOV DX,BX
FXD:	MOV CX,00		;CL -> decades. CH ->hundreds.
	MOV BX,00
CADES:	CMP DX,0AH		;BL -> units. BH -> thousands
	JL THOU
	SUB DX,0AH
	INC CL
	CMP CL,0AH
	JL CADES
	SUB CL,0AH
	INC CH
	JMP CADES
THOU:	MOV BL,DL
	MOV BH,00
LOOPB:	CMP CH,0AH
	JL NOTH
	SUB CH,0AH
	INC BH
	JMP LOOPB
NOTH:	CMP BH,0
	JE NOO
	MOV DL,BH
	ADD DL,30H
	MOV AH,02H
	INT 21H
NOO:	MOV DL,CH
	ADD DL,30H
	MOV AH,02H
	INT 21H
	MOV DL,CL
	ADD DL,30H
	MOV AH,02H
	INT 21H
	MOV DL,BL
	ADD DL,30H
	MOV AH,02H
	INT 21H
	MOV DX,BP
	POP CX
	POP BX
	RET
POSI:	ROR DX,1
	JMP FXD
PRT_DEC	ENDP
LIB	ENDS
	END
;================================================================
