;***************************R*S*2*3*2*-*-*-*-*-*B*A*S*I*C**L*I*B*R*A*R*Y*********************************
;*                  This library defines the three basic procedures we need to communicate              *
;*                  via UART(Universal Asynchronus Receiver Transmitter) 8250,RS232 standard            *
;*							1.OPEN_RS232	initializes RS232 standard communication					*
;*							2.RXCH_RS232	READS a char from serial port								*
;*							3.TXCH_RS232	SENDS a char to serial port									*
;********************************************************************************************************
DEFINE_OPEN_RS232 MACRO
LOCAL START,SKIP_OPEN_RS232
JMP SKIP_OPEN_RS232

;This routine initializes RS232 standard communication
;Messes with AX,DX,DI
OPEN_RS232 PROC NEAR
	JMP START
	BAUD_RATE_DIVISOR LABEL WORD	;divisor=115200/baud_rate, same declaration as
	DW 1047	;110  baud rate		(OFFSET BAUD_RATE_DIVISOR)+0	BR=000	;BAUD_RATE_DIVISOR DW 1047,768,384,192,96,48,24,12
	DW 768 	;150  baud rate		(OFFSET BAUD_RATE_DIVISOR)+2	BR=001
	DW 384 	;300  baud rate		(OFFSET BAUD_RATE_DIVISOR)+4	BR=010
	DW 192 	;600  baud rate		(OFFSET BAUD_RATE_DIVISOR)+6	BR=011
	DW 96 	;1200 baud rate		(OFFSET BAUD_RATE_DIVISOR)+8	BR=100		
	DW 48 	;2400 baud rate		(OFFSET BAUD_RATE_DIVISOR)+10	BR=101
	DW 24 	;4800 baud rate		(OFFSET BAUD_RATE_DIVISOR)+12	BR=110
	DW 12 	;9600 baud rate		(OFFSET BAUD_RATE_DIVISOR)+14 	BR=111 "+14->LSByte, +15->MSByte"
START: 
	STI 	;Set interrupt flag != CLI; Clear Interrupt Flag (?)
; Initial Values of RS232
	MOV AH,AL 		;AH<-AL parameters:BR2|BR1|BR0|EVEN_OR_ODD_PARITY|PARITY_ON|NUM_STOP_BIT|WORD_LENGTH_1|WORD_LENGTH_0
	MOV DX,3FBH 	;Line Control REGISTER address
	MOV AL,80H		;AL<-1000 0000 : DLAB=1
	OUT DX,AL		;send to register
	MOV DL,AH		;DL<- Parameters
	ROL	DL,4
	AND DX,0EH		;DH<-00H, DL<-0000 BR2|BR1|BR0|0 --->offset=0,2,4,6,8,10,12,14
	MOV DI,OFFSET BAUD_RATE_DIVISOR
	ADD DI,DX		;DI<-memory address of correct divisor
	MOV DX,3F9H		;MSByte of Baudrate divisor REGISTER adddress (DLAB=1)
	MOV AL,CS:[DI]+1;CS:[DI]+1 -> MSByte of divisor
	OUT DX,AL		;send to register
	MOV DX,3F8H		;LSByte of Baudrate divisor (DLAB=1)
	MOV AL,CS:[DI]	;CS:[DI]   -> LSByte of divisor
	OUT DX,AL		;send to register
	MOV DX,3FBH		;Line Control REGISTER address
	MOV AL,AH		;AL<-parameters
	AND AL,1FH		;AL<-0(DLAB)|0(SOUT not deactivated)|0(normal parity bit)|EVEN_OR_ODD_PARITY|PARITY_ON|NUM_STOP_BIT|WORD_LENGTH_1|WORD_LENGTH_0
	OUT DX,AL		;send to register
	MOV DX,3F9H		;Interrupt Enable REGISTER address
	MOV AL,0		;disabled interrupts 0	Rx data int. enable
				;1	Tx holding reg. empty int.
				;2	Rx status int. enable (ie Parity, Framing, overrun and BREAK enable).
				;3	Modem signal change int. enable.
	OUT DX,AL
	RET
OPEN_RS232 ENDP

SKIP_OPEN_RS232:
	DEFINE_OPEN_RS232 ENDM
;***********************************************************************************************	
DEFINE_RXCH_RS232 MACRO
LOCAL END_RXCH_RS232
LOCAL SKIP_RXCH_RS232
JMP SKIP_RXCH_RS232

;This routine READS a char from serial port
;Messes with AL,DX
RXCH_RS232 PROC NEAR
	MOV DX,3FDH			;Line Status REGISTER Address
	IN AL,DX			;Input Status of Line (to check if there is something to read)
	AND AL,1			;AL (AND) 00000001 ->IF NonZero => DR=1 => something has come
	JZ END_RXCH_RS232	;AL<-0(NUL) means there is nothing to Read (!*Hope we don't receive NUL char from serial port*!)
	MOV DX,3F8H			;Data Read/Write REGISTER address.
	IN AL,DX			;READ IT!
END_RXCH_RS232:
	RET
RXCH_RS232 ENDP

SKIP_RXCH_RS232:
	DEFINE_RXCH_RS232 ENDM
;***********************************************************************************************
DEFINE_TXCH_RS232 MACRO
LOCAL SKIP_TXCH_RS232
LOCAL TXCH_RS232_2
JMP SKIP_TXCH_RS232

;This routine SENDS a char to serial port
;Messes with AL(there is the CHAR_2_SEND),DX
TXCH_RS232 PROC NEAR
	PUSH AX
	MOV DX,3FDH			;Line Status Register Address
TXCH_RS232_2:
	IN AL,DX			;Input Status of Line (to check if TRANSMITTER REGISTER is clear to send)
	TEST AL,20H			;AL (AND) 0010 0000 ->IF NonZero => THRE=1 => Transmitter Holding Register is empty, we can send
	JZ TXCH_RS232_2			;Loop from proc_begin, until Transmitter Register is empty!
	MOV DX,3F8H			;Data Read/Write REGISTER address.
	POP AX				;Retrieve AL<-CHAR_2_SEND
	OUT DX,AL			;Send it to Transmitter Register(=Data Read/Write Register)
	RET
TXCH_RS232 ENDP

SKIP_TXCH_RS232:
	DEFINE_TXCH_RS232 ENDM
