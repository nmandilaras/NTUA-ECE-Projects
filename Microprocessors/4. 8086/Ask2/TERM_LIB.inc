;************************************PROJECT****4-2***LIBRARY********************************************
;*                  This library defines three procedures                                               *
;*                                                                                                      *
;*							1.INPUT_CHOOSE		initializes ECHO CHOICE and BAUD RATE					*
;*							2.PRINT_START_SCRN	prints the main screen									*
;*							3.MAIN_LOOP			main loop procedure of our program						*
;********************************************************************************************************
DEFINE_INPUT_CHOOSE MACRO
LOCAL ECHO_ERR,BAUD_RATE_ERR
LOCAL SKIP_INPUT_CHOOSE
JMP SKIP_INPUT_CHOOSE

INPUT_CHOOSE PROC NEAR
    SCROLL_UP_WIN 0 0 24 80 0
    LOCATE 0 0 0 
    PRINT_STRING ECHO_MSG
ECHO_ERR:
    READ    
    CMP AL,30H
    JB ECHO_ERR
    CMP AL,31H
    JA ECHO_ERR
    PRINT AL
    SUB AL,30H
    MOV ECHO_FLG,AL
    PRINT_STRING NEW_LINE
    PRINT_STRING BAUD_RATE_MSG
BAUD_RATE_ERR:
    READ
    CMP AL,31H
    JB BAUD_RATE_ERR
    CMP AL,36H
    JA BAUD_RATE_ERR
    PRINT AL
    SUB AL,2FH          ;example(gave '1'):31h=29h=2h->010->baud rate 300
	SHL AL,5                        ;AL<-xxx0 0000
	AND AL,0E0H
	ADD AL,3                        ;AL<-xxx0 0011 (xxx||EVEN_OR_ODD_PARITY|PARITY_ON|NUM_STOP_BIT|WORD_LENGTH_1|WORD_LENGTH_0)
	MOV B_R_CHOICE,AL
    PRINT_STRING NEW_LINE
    PRINT_STRING PKEY
    READ
    SCROLL_UP_WIN 0 0 3 80 0
	RET
INPUT_CHOOSE ENDP

SKIP_INPUT_CHOOSE:
	DEFINE_INPUT_CHOOSE ENDM
;********************************************************************************************************
DEFINE_PRINT_START_SCRN MACRO
LOCAL SKIP_PRINT_START_SCRN
JMP SKIP_PRINT_START_SCRN

PRINT_START_SCRN PROC NEAR
    LOCATE 0 0 00H
    PRINT_STRING LOC_MSG
    MOV LOCAL_LIN,1
    LOCATE 11 0 00H
    PRINT_STRING SEPERATOR
    LOCATE 12 0 0
    PRINT_STRING REM_MSG
    MOV REMOTE_LIN,13
	RET
PRINT_START_SCRN ENDP

SKIP_PRINT_START_SCRN:
	DEFINE_PRINT_START_SCRN ENDM
;********************************************************************************************************
DEFINE_MAIN_LOOP MACRO
LOCAL FULL_REM_WIN,KEY_RECEIVED
LOCAL FULL_REM_WIN_2,GO_PRINT_RECEIVED
LOCAL SEND_CHECK,FULL_LOC_WIN
LOCAL KEY_PUSHED,FULL_LOC_WIN_2
LOCAL GO_PRINT,GO_ON_SEND
LOCAL SKIP_MAIN_LOOP
JMP SKIP_MAIN_LOOP

MAIN_LOOP PROC NEAR
	CALL RXCH_RS232		;AL<-0 (NUL) means there is nothing to Read 
	CMP AL,0			;else AL<-char received
	JE SEND_CHECK
;[section=CHAR RECEIVED]
	CMP AL,0DH			;check if ENTER received
	JNE KEY_RECEIVED	;if not ENTER jump to KEY_PUSHED
	CMP REMOTE_LIN,22	;Lines can be printed-limit
	JE FULL_REM_WIN
	ADD REMOTE_LIN,1
	MOV REMOTE_COL,0
	JMP SEND_CHECK
FULL_REM_WIN:
	SCROLL_UP_WIN 13 0 22 79 1
	MOV REMOTE_COL,0
	JMP SEND_CHECK
KEY_RECEIVED:
	CMP REMOTE_COL,80	;0-79 column have been written (80 chars)
	JNE GO_PRINT_RECEIVED
	CMP REMOTE_LIN,10	;Lines can be printed-limit
	JE FULL_REM_WIN_2
	ADD REMOTE_LIN,1
	MOV REMOTE_COL,0
	JMP GO_PRINT_RECEIVED
FULL_REM_WIN_2:
	SCROLL_UP_WIN 13 0 22 79 1
	MOV REMOTE_COL,0
GO_PRINT_RECEIVED:
	LOCATE REMOTE_LIN REMOTE_COL 0
	PRINT AL
	ADD REMOTE_COL,1
;[\section]
SEND_CHECK:
	READ_NW				;if ZF=0 there was something to read (in AL)
	JZ MAIN_LOOP		;if ZF=1 loop!
	CMP AL,1BH			;check if ESC
	JE EXODOS
	CMP ECHO_FLG,1
	JNE GO_ON_SEND
;[section=ECHO ON]
	CMP AL,0DH			;check if ENTER
	JNE KEY_PUSHED		;if not ENTER jump to KEY_PUSHED
	CMP LOCAL_LIN,10	;Lines can be printed-limit
    JE FULL_LOC_WIN
    ADD LOCAL_LIN,1
    MOV LOCAL_COL,0
	JMP GO_ON_SEND
FULL_LOC_WIN:
	SCROLL_UP_WIN 1 0 10 79 1
	MOV LOCAL_COL,0
	JMP GO_ON_SEND
KEY_PUSHED:
	CMP LOCAL_COL,80	;0-79 column have been written (80 chars)
	JNE GO_PRINT
	CMP LOCAL_LIN,10	;Lines can be printed-limit
    JE FULL_LOC_WIN_2
    ADD LOCAL_LIN,1
    MOV LOCAL_COL,0
	JMP GO_PRINT
FULL_LOC_WIN_2:
	SCROLL_UP_WIN 1 0 10 79 1
	MOV LOCAL_COL,0
GO_PRINT:
	LOCATE LOCAL_LIN LOCAL_COL 0
	PRINT AL
	ADD LOCAL_COL,1 	
;[\section]
GO_ON_SEND:
	CALL TXCH_RS232
	JMP MAIN_LOOP
	RET				;not necessary, because it's infinite loop(ends with jump to EXODOS)
MAIN_LOOP ENDP 

SKIP_MAIN_LOOP:
	DEFINE_MAIN_LOOP ENDM
;****************************************************************************************