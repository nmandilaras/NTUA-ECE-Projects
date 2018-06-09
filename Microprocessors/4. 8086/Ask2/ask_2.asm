INCLUDE MACROS.TXT
INCLUDE EXTRA_MACROS.TXT
INCLUDE RS232_ROUTINES.INC
INCLUDE TERM_LIB.INC

org 100h

.data
    PKEY DB "Press any key...$"
    NEW_LINE DB 0AH,0DH,"$"
    LOC_MSG DB "LOCAL$"
    REM_MSG DB "REMOTE$"
    SEPERATOR DB 80 DUP(0C4H),"$"
    ECHO_MSG DB "With(1) or Without(0) ECHO? $"
    BAUD_RATE_MSG DB "Give Baud Rate:(1)300,(2)600,(3)1200,(4)2400,(5)4800,(6)9600:$"
    LOCAL_LIN DB 0
	LOCAL_COL DB 0
    REMOTE_LIN DB 12
	REMOTE_COL DB 0
	WHERE_2_WRITE DB 0 
	ECHO_FLG DB 0
	B_R_CHOICE DB 0

.code

MAIN PROC FAR
;=-=-=-=-==-=-=-=-=-=-=-CODE-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=
START:
    CALL INPUT_CHOOSE
    MOV AL,B_R_CHOICE               ;sthing 0000 0xxx     
    CALL OPEN_RS232
;    MOV AH,00H
;    MOV AL,7
;    INT 10H
    CALL PRINT_START_SCRN
    CALL MAIN_LOOP
;    CALL INPUT_METHOD
;    READ
EXODOS:
    SCROLL_UP_WIN 0 0 24 80 0       ;to clear screen
    LOCATE 0 0 0                    ;to locate at the begining
    EXIT    
MAIN ENDP
;*****************************************************************        


DEFINE_OPEN_RS232
DEFINE_RXCH_RS232
DEFINE_TXCH_RS232
DEFINE_INPUT_CHOOSE
DEFINE_PRINT_START_SCRN
DEFINE_MAIN_LOOP


