; press 05


.include "m16def.inc"

.def temp = r16

.DSEG
_tmp_: .byte 2

.CSEG
.org 0x00
    rjmp RESET              ; Start of main program.



RESET:
    
	ldi r24, LOW(RAMEND)    ; Initialise stack pointer.
    out SPL, r24            
    ldi r24, HIGH(RAMEND)   
    out SPH, r24            
    
	ser r23                
    out DDRB, r23           ; PORTB as output.
	ldi r24, 0xf0           ; Turn off low nibble of r24.
    out DDRC, r24           ; High nibble of PORTC: output, low nibble: input.
	clr r23
    out PORTB, r23          ; Turn B-LEDs off.
	


FIRST_NUMBER:
	ldi r24,10             ; Allow for 10ms debouncing time.
    rcall scan_keypad_rising_edge ; Read pressed buttons in r25:r24.
    rcall keypad_to_ascii
    
	
	ldi temp, '0'
    
	cp r24, temp            ; Skip loop-back if 0 was pressed.
    brne FIRST_NUMBER

SECOND_NUMBER:
	ldi r24, 10             	; Allow for 10ms debouncing time.
    rcall scan_keypad_rising_edge ; Read pressed buttons in r25:r24.
	rcall keypad_to_ascii   	; Convert to ASCII

	cpi r24, 0            ; Skip loop-back if 0 was pressed.
	breq SECOND_NUMBER 
	cpi r24, '0'            ; Skip loop-back if 0 was pressed.
	breq SECOND_NUMBER

	


	ldi temp, '5'           
    cp r24, temp            ; Skip loop-back if 5 was pressed.
    brne FIRST_NUMBER

	
CODE_VERIFIED:	

	ser r23                 ; Light all B-LEDs.
    out PORTB, r23
    ldi r24, LOW(3000)      ; Pause for 3sec.
    ldi r25, HIGH(3000)
    rcall wait_msec			

	clr r23					; Turn-off all A-LEDs
	out PORTB, r23
    
    rjmp FIRST_NUMBER              ; Loop endlessly...






scan_keypad_rising_edge:
	mov r22 ,r24 
	rcall scan_keypad 
	push r24 
	push r25
	mov r24 ,r22 
	ldi r25 ,0 
	rcall wait_msec
	rcall scan_keypad 
	pop r23 
	pop r22 
	and r24 ,r22
	and r25 ,r23
	ldi r26 ,low(_tmp_) 
	ldi r27 ,high(_tmp_) 
	ld r23 ,X+
	ld r22 ,X
	st X ,r24 
	st -X ,r25 
	com r23
	com r22 
	and r24 ,r22
	and r25 ,r23
	ret




scan_keypad:
	ldi r24 ,0x01 
	rcall scan_row
	swap r24 
	mov r27 ,r24 
	ldi r24 ,0x02 
	rcall scan_row
	add r27 ,r24 
	ldi r24 ,0x03 
	rcall scan_row
	swap r24 
	mov r26 ,r24 
	ldi r24 ,0x04 
	rcall scan_row
	add r26 ,r24 
	movw r24 ,r26 
	ret





keypad_to_ascii: 
	movw r26 ,r24 
	ldi r24 ,'*'
	sbrc r26 ,0
	ret
	ldi r24 ,'0'
	sbrc r26 ,1
	ret
	ldi r24 ,'#'
	sbrc r26 ,2
	ret
	ldi r24 ,'D'
	sbrc r26 ,3 
	ret 
	ldi r24 ,'7'
	sbrc r26 ,4
	ret
	ldi r24 ,'8'
	sbrc r26 ,5
	ret
	ldi r24 ,'9'
	sbrc r26 ,6
	ret
	ldi r24 ,'C'
	sbrc r26 ,7
	ret
	ldi r24 ,'4' 
	sbrc r27 ,0 
	ret
	ldi r24 ,'5'
	sbrc r27 ,1
	ret
	ldi r24 ,'6'
	sbrc r27 ,2
	ret
	ldi r24 ,'B'
	sbrc r27 ,3
	ret
	ldi r24 ,'1'
	sbrc r27 ,4
	ret
	ldi r24 ,'2'
	sbrc r27 ,5
	ret
	ldi r24 ,'3'
	sbrc r27 ,6
	ret
	ldi r24 ,'A'
	sbrc r27 ,7
	ret
	clr r24
	ret



wait_msec:
	push r24 		
	push r25 		
	ldi r24 , low(998) 	
	ldi r25 , high(998) 	
	rcall wait_usec 	
	pop r25 		
	pop r24 		
	sbiw r24 , 1 		
	brne wait_msec 		
	ret 			




wait_usec:
	sbiw r24 ,1 
	nop 			
	nop 			
	nop 			
	nop 		
	brne wait_usec 		
	ret 			


scan_row:
	ldi r25 ,0x08 
back_: lsl r25 
	dec r24 
	brne back_
	out PORTC ,r25 
	nop
	nop 
	in r24 ,PINC 
	andi r24 ,0x0f 
	ret 


