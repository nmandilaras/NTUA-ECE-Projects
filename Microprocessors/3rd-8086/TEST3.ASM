D_SEG SEGMENT
INPUT DB 15 DUP(0)
CAPS  DB 15 DUP(?)
SMALL DB 15 DUP(?)
NUMSv DB 15 DUP(?)		;here goes nothing
C1    DW 00			;three counters
C2    DW 00
C3    DW 00
NUMS  DB 15 DUP(?)
NMAX  DB 00
OMAX  DB 00
D_SEG ENDS
;======================================================================
C_SEG SEGMENT
	ASSUME CS:C_SEG,DS:D_SEG
MAIN PROC FAR
LOOPA:
	CALL READ
	CALL PRINT
	CALL MAXEN
	JMP LOOPA
MAIN ENDP
;======================================================================
READ PROC NEAR			;READ properly loads input at INPUT
	LEA BX,INPUT		;array, also sets CAPS, SMALL and 
	MOV CL,15		;NUMS arrays
	MOV C1,0		;initialize counters
	MOV C2,0
	MOV C3,0
LOOPB:
	MOV AH,07H		;read next character (without echo,
	INT 21H			;just to be safe)
CHKSP:	
	CMP AL,20H		;was it space?
	JNZ CHKNUM		;if not, check if it was a number
	JMP STRE		;else store and proceed
CHKNUM:
	CMP AL,30H
	JGE UPPER
	CMP AL,0DH		;only possible key is ENTER
	JZ DONE			;if pressed, get out
	JMP LOOPB		
UPPER:
	CMP AL,39H
	JG KEEP
	MOV DX,BX		;found a number! save it!
	LEA BX,NUMS
	ADD BX,C1		;align
	MOV [BX],AL
	MOV CH,20H
	INC BX
	MOV [BX],CH
	INC C1
	MOV BX,DX		;retrieve pointer
	JMP STRE
KEEP:
	CMP AL,3DH		;check for '='
	JZ KILL
	CMP AL,41H		;check for caps...
	JL LOOPB
	CMP AL,5AH
	JG KEEP2
	MOV DX,BX		;found a CAP! save it!
	LEA BX,CAPS
	ADD BX,C2		;align
	MOV [BX],AL
	MOV CH,0AH
	INC BX
	MOV [BX],CH
	INC C2
	MOV BX,DX		;retrieve pointer
	JMP STRE
KEEP2:
	CMP AL,61H		;check for small...
	JL LOOPB
	CMP AL,7AH
	JG LOOPB		;if nothing valid, wait for new input
	MOV DX,BX		;found a small! save it!
	LEA BX,SMALL
	ADD BX,C3		;align
	MOV [BX],AL
	MOV CH,20H
	INC BX
	MOV [BX],CH
	INC C3
	MOV BX,DX		;retrieve pointer
STRE:	
	MOV [BX],AL		;store char at input array
	DEC CL			;update counter
	JZ DONE			;also check if array is full
	INC BX			;update pointer
	MOV AH,02H
	MOV DL,AL
	INT 21H			;print VALID character
	JMP LOOPB
DONE:
	MOV AH,02H
	MOV DL,0AH		;print a new line when finished
	INT 21H
	LEA BX,SMALL		;just in case input does not contain
	MOV AL,20H		;a certain kind of character (numbers,
	ADD BX,C3		;for example).
	MOV [BX],AL
	LEA BX,NUMS
	MOV AL,20H
	ADD BX,C1
	MOV [BX],AL
	LEA BX,CAPS
	MOV AL,0AH
	ADD BX,C2
	MOV [BX],AL
	RET
KILL:
	MOV AH,4CH		;terminate program
	INT 21H
	RET
READ ENDP
;======================================================================
PRINT PROC NEAR
	MOV CL,00H		;something like a flag	
	LEA BX,SMALL
LOOPC:
	MOV DL,[BX]
	CMP DL,20H		;we know array ends at 'SPACE'
	JZ NXT1
	INC CL			;if at least one character has	
	MOV AH,02H		;been given, raise the flag
	INT 21H
	INC BX			;point at next char
	JMP LOOPC
NXT1:
	CMP CL,00H		;flag check (no point printing
	JZ B1			;'SPACE' if no small char was
	MOV AH,02H		;given)
	INT 21H
	MOV CL,00H
B1:
	LEA BX,NUMS		;identical procedure for numbers..
LOOPv:
	MOV DL,[BX]
	CMP DL,20H
	JZ NXT2
	INC CL
	MOV AH,02H
	INT 21H
	INC BX
	JMP LOOPv
NXT2:
	CMP CL,00H
	JZ B2
	MOV AH,02H
	INT 21H	
B2:
	LEA BX,CAPS		;...and for the CAPS, except we
LOOPg:				;print a new line at array end
	MOV DL,[BX]
	CMP DL,0AH
	JZ COOL
	MOV AH,02H
	INT 21H
	INC BX
	JMP LOOPg
COOL:
	MOV DL,0AH	
	MOV AH,02H
	INT 21H
	RET
PRINT ENDP	
;======================================================================
MAXEN PROC NEAR
	LEA BX,NUMS		;go at the numbers
	MOV DL,[BX]
	MOV NMAX,DL		;define first number as max
	MOV OMAX,20H		;the "old" max is nothing, for now
SCOUT:
	MOV DL,[BX]
	CMP DL,20H		;finished?
	JZ LEAVES
	CMP DL,NMAX		;if not, compare with new max
	JG NFOUND		
	CMP DL,OMAX		;...and with "old" max
	JG OFOUND
BACKIN:
	INC BX			;point at next number
	JMP SCOUT
NFOUND:
	MOV DL,NMAX	
	MOV OMAX,DL		;give old max the new max's old value
	MOV DL,[BX]		;update new max
	MOV NMAX,DL
	JMP BACKIN
OFOUND:
	MOV DL,[BX]
	CMP DL,NMAX		;just in case there was only one number
	JZ BACKIN	
	MOV DL,[BX]
	MOV OMAX,DL
	JMP BACKIN
LEAVES:
	MOV DL,NMAX		;print the results
	MOV AH,02H
	INT 21H
	MOV DL,OMAX
	MOV AH,02H
	INT 21H
	MOV DL,0AH		;also print a new line
	MOV AH,02H
	INT 21H
	RET
MAXEN ENDP
;======================================================================
C_SEG ENDS
END MAIN
