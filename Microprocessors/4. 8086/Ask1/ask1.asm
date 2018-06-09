EXTRN	RD_HX:FAR
EXTRN	PRT_HX:FAR
EXTRN	PRT_DEC:FAR

D_SEG	SEGMENT
NUM1	DW	0
BUFF	DB	2 DUP(?)
NUM2	DW	0
OPER	DB	0
RESUL	DW	0
D_SEG	ENDS
;================================================================
C_SEG 	SEGMENT
	ASSUME CS:C_SEG,DS:D_SEG
MAIN 	PROC 	FAR
GIVE1:	CALL RD_HX
	MOV NUM1,DX		;save number
	CMP AL,2BH		;digit last given?
	JGE SYM1		;symbol, then
GVSM1:	MOV AH,07H		;read symbol(no echo)
	INT 21H
SYM1:	CMP AL,2BH
	JE GIVE2
	CMP AL,2DH		;accept only '+','-' or 'Q' here
	JE GIVE2
	CMP AL,51H
	JNE GVSM1
KILL:	MOV AH,4CH		;if it was 'Q', finish
	INT 21H		
GIVE2:	MOV OPER,AL		;save operator
	MOV DL,AL		;print operator
	MOV AH,02H
	INT 21H
	CALL RD_HX
	MOV NUM2,DX
GVSM2:	CMP AL,3DH		;accept only '=', 'Q' here
	JE RATE
	CMP AL,51H
	JE KILL
	MOV AH,07H
	INT 21H
	JMP GVSM2
RATE:	MOV DL,AL
	MOV AH,02H
	INT 21H
	MOV DX,NUM1
	CMP OPER,2BH
	JNE MINUS
	ADD DX,NUM2		;result is ready
	JMP GOOD
MINUS:	SUB DX,NUM2
GOOD:	MOV RESUL,DX
	CALL PRT_HX
	MOV DL,3DH		;print '='
	MOV AH,02H
	INT 21H
	MOV DX,RESUL
	CALL PRT_DEC
	MOV DL,0DH		;carriage return
	MOV AH,02H
	INT 21H
	MOV DL,0AH		;new line
	MOV AH,02H
	INT 21H
	JMP GIVE1
MAIN	ENDP
;================================================================
C_SEG ENDS
END MAIN
