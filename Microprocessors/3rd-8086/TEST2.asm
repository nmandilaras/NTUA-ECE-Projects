data segment
msg1 db 0AH,0DH,"GIVE DECIMAL DIGITS:$"
msg2 db 0AH,0DH,"HEX=$"
ends
stack segment
dw 128 dup(0)
ends 

code segment
start:
; set segment registers:
mov ax, data
mov ds, ax
mov es, ax   

start1:
 
ignore: 
 
mov CX, 0h
mov dx,0

PRINT_STR msg1

tag1: 
mov ax,10           ; polaplasise me 10
mul dx              ; ton mexri tora arithmo
mov dx,ax 
mov BX, DX             ; Save DX at BX.

loopi:

READ 

;cmp AL, 0Dh     ; 0Dh = 13d = chr(\n)
;    je CONT   ; Loop until [ENTER] is pressed.

cmp al,'0'
jl loopi
cmp al,'9'
jg LOOPI
cmp AL, 0Dh     ; 0Dh = 13d = chr(\n)
je CONT   ; Loop until [ENTER] is pressed.

;CMP CX, 4h
;Jl PAK  

push ax
PRINT al 
POP AX  

mov AH, 0       ; Zero AX's high byte.
sub AX, 48      ; 48 = chr(0).
add DX, AX      ; Add AX to DX.
mov BX, DX      ; Save DX at BX.
    
cmp cx , 3h
jl pak

ENTERLOOP:
    READ            ; Awaits for [ENTER]
    cmp AL, 0Dh     ; 0Dh = 13d = chr(\n)
    je cont   ; Loop until [ENTER] is pressed.
    
pak:
ADD CX , 1h
    
JMP TAG1

cont:

;MOV AX,BX 
;MOV BL,10
;DIV BL
;MOV BX,AX

MOV AL,00H
mov CX, 4       ; Set loop counter (4 digits). 
PRINT_STR msg2 
    
tupoma: ;fere t 4 prota bits se 8esh gia print      
   
    rol BX, 1       ; Right-shift BX by one nibble
    rol BX, 1       ; ...
    rol BX, 1       ; ...
    rol BX, 1       ; ...
    mov DX, BX      ; Save shifted number to DX.  
        and DX, 000Fh   ; Mask 4 lowest bits of DX.
   
    call PRINT_HEX 
     
;49232  MAS KANEI C05 POU EINAI H OMADA MAS--------------    

CMP AL,10H
JZ PAKTELOS


CMP DL, 'C'
JNZ PAK2
CMP AL,00H 
JZ PAKADD

PAK2:              
CMP DL, '0'
JNZ PAK3     
CMP AL , 01H 
JZ PAKADD 

PAK3:
CMP DL , '5'
JNZ PAKTELOS 
CMP DL, 02H
JZ  PAKTELOS:

JMP TELOS
PAKTELOS: 
MOV AL,10H 
JMP LOOPA

PAKADD: ADD AL,1H  


LOOPA:
loop tupoma
jmp start1  


;-------------------------------------------------------------------------
PRINT_HEX proc near
    cmp DL, 9       ; DL <= 9?
    jle _ADD10      ; yes: jump to appropriate fixing code.
    add DL, 37H     ; no : Prepare DL by adding chr(A) - 10d = 37h 
    jmp _HEX_OUT    ; ... and go to output stage
_ADD10:
    add DL, 30h     ; Prepare DL by adding chr(0) = 30h
_HEX_OUT:
    PRINT DL        ; Print char to screen.
    ret             ; Return to caller.
PRINT_HEX endp


PRINT macro CHAR
 push AX ; Save AX on stack.
 push DX ; Save DX on stack.
 mov DL, CHAR ; Place char byte in DL
 mov AH, 2 ; Load DOS operation.
 int 21H ; Call DOS.
 pop DX ; Restore DX.
 pop AX
endm

PRINT_STR macro STRING
	push AX ; Save AX on stack.
	push DX ; Save DX on stack
	lea DX, STRING ; Load address of string @ DX
	mov AH, 9 ; Load DOS operation
	int 21H ; Call DOS.
	pop DX ; Restore DX.
	pop AX ; Restore AX.
endm

READ MACRO
    MOV AH,08H
    INT 21H
ENDM

EXIT MACRO
    MOV AH,4CH
    INT 21H
ENDM

telos: exit
ends
end start ; set entry point and stop the assembler.