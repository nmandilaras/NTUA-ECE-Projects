org 100h   

.DATA
   MSG1 DB 'GIVE AN 8-BIT BINARY NUMBER: $'
   MSG2 DB 'DECIMAL: $' 
   linefeed db 13, 10, "$"
 
.CODE   
INIT: 
; MOV AX,@DATA
; MOV DS,AX
 MOV DX,OFFSET MSG1    ;typwnw mhnuma sthn othonh
 MOV AH,09H
 INT 21H  
 MOV CL,0    ; deikths
 MOV BL,128    ;voithitiko ginomeno
 MOV BH,0    ; arithmos/athroisma
 MOV CH,2  
 
READ:  
 MOV AH,00H
 INT 16H
 CMP AL,'Q' 
 JE RETURN     ; an Q diakoptw
 CMP AL,30H    ; an oxi 0 tsekarw an einai 1
 JE ELE
  
UNO:
 CMP AL,31H
 JA READ       ;an oxi 1 janazhtaw eisodo
 ADD BH,BL     ;prosthetw to voithiko ginomeno sto athroisma
ELE: 
 MOV DL,AL
 MOV AH,02H
 INT 21H
 MOV AH,0
 MOV AL,BL     
 DIV CH       ;diairw me 2 to voithiko ginomeno
 MOV BL,AL
 INC CL        ; auxanw ton deikth
              
 CMP CL,8     ;elegxw an diavasa 8bit
 JB READ  
 
PRINT:
 MOV AH, 09            ;allazw grammh
 MOV DX, offset linefeed
 INT 21h               ;an nai typwnw mhnyma kai apotelesma
; MOV AX,@DATA
; MOV DS,AX
 MOV DX,OFFSET MSG2
 MOV AH,09H
 INT 21H  
 
BCD:
 MOV CL,1 ;FLAG yparxoyn ekatontades
          
 CMP BH,200 ; compare with 200
 JB SM200	
 SUB BH,200 ; AL-=200
 MOV AL,02H   ; ekatontades = 2
 JMP DECS
 
 SM200:				; <200
 CMP BH,64H	; compare with 100
 JB SM100
 SUB BH,64H	; AL-= 100
 MOV AL,01H	; ekatontades = 1
 JMP DECS
SM100:		
 MOV AL,00H	; ekatontades = 0       
 MOV CL,0
 JMP NEXT   ;An ekatontades mhden mhn tis typwseis
DECS:   
 MOV DL,AL
 ADD DL,30H ;typwma ekatontades
 MOV AH,02H
 INT 21H	; restore from b  
NEXT: 
 MOV AL,00H	; dekades = 0
LOOP0:		
 CMP BH,0AH	; compare with 10
 JB SM10
 INC AL		; dekades ++
 SUB BH,0AH	; AL -= 10
 JMP LOOP0
SM10:				;<10  
 CMP AL,0    ;eleje an yparxoyn dekades
 JA GOOD     ;an nai typwnw kanonika
 CMP CL,0    ;alliws an kai oi ekatontades mhden feygw
 JE NON 
GOOD: 
 MOV DL,AL
 ADD DL,30H
 MOV AH,02H
 INT 21H          ;typwma dekadwn 
NON: 
 MOV DL,BH
 ADD DL,30H
 MOV AH,02H
 INT 21H          ;typwma monadwn
 MOV AH, 09
 MOV DX, offset linefeed    ;typwma xaraktira allaghs grammhs
 INT 21h 
 JMP INIT      ; synexomenh leitoyrgia 
 
RETURN:
RET
END