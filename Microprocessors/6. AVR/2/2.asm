/*
 * _6.asm
 *
 *  Created: 11/27/2015 7:58:59 PM
 *   Author: Abdul
 */ 
.include "m16def.inc"

; orisma metablhtwn
.def status = r16
.def check  = r19
.def counter= r20
.def inter  = r21

; arxikopoihsh diakophs
.org 0x0 
rjmp reset 
.org 0x2									; h INT0
rjmp ISR0									; orizetai sto 0x2

RESET:
    ldi status, low(RAMEND)					; Initialize stack pointer.
    out SPL, status							
    ldi status, high(RAMEND)				
    out SPH, status						    

; upoloipes arxikopoihseis thirwn
	ldi r24 ,( 1 << ISC01) | ( 1 << ISC00)  ; h diakoph INT0 orizetai me shma thetikhs akmhs
	out MCUCR , r24						    
	ldi r24 ,( 1 << INT0)					; turn on INT0
	out GICR , r24
	sei										; turn on interrupts
; arxikopoiseis eiswdwn eksodwn
    clr status            
    out DDRA, status					    ; PORTA as input. 
    ser status                
    out DDRC, status						; PORTc as output.
    clr counter								; initialize counter = 0


LOOP:
	out PORTB,counter						; show counter on portB
	ldi r24, low(200)
    ldi r25, high(200)
    rcall wait_msec							; Delay for 200msec.
	inc counter
	rjmp LOOP



;;;;;;;;;;;;;;;;;;;;;;;;;; ws edw swsto
ISR0:
BLOOP:
	ldi status, (1 << INTF1)				; Put a 1 in GIFR's INTF1 bit to test for bouncing.
    out GIFR, status        
    push r24								; Save r24 and r25 on stack.
    push r25
    ldi r24, low(5)
    ldi r25, high(5)
    rcall wait_msec							; Delay for 5msec.
    pop r25									; Restore r24 and r25 from stack.
    pop r24
	in status, GIFR							; Read GIFR once more to ensure no bouncing.
    andi status, 0x80						; Select INTF1 bit.
    brne BLOOP								; Loop until the INTF1 bit stabilizes to 0.
    clr counter								; Zero ON counter.
    clr inter								; Zero loop counter.
    
	in status, PIND         
    sbrs status,7
	rjmp TELOS

	
	in status, PINA							; Get PORTA as input.
LOOPA:
	sbrc status, 0						    ; Only increase ON counter if LSB switch is 1.
  	inc counter								; [skip otherwise].
   	lsr status								; Get next switch in LSB position.
    inc inter								; Advance loop counter.
	cpi inter,0x08						    ; Break loop if idxr >= 8.
	brne LOOPA								; Loop for next DIP Switch.
    out PORTC, counter						; Show interrupt counter on C-LEDs.
 TELOS:
    reti									; Terminate routine.



; == wait_msec ==
; Treats (r25:r24) as a 16-bit value K.
; Causes a delay almost equal to K msec. Calls wait_usec.
; MODIFIES: r24, r25, SPL, SPH.
wait_msec:
    push r24                ; Save r24 on the stack.
    push r25                ; Save r25 on the stack.
    ldi r24, low(998)       ; (r25:r24) = 998
    ldi r25, high(998)      ; ...
    rcall wait_usec         ; Cause a ~1msec delay.
    pop r25                 ; Restore r25 from stack.
    pop r24                 ; Restore r24 from stack.
    sbiw r24, 1             ; Decrease (r25:r24).
    brne wait_msec          ; Loop until (r25:r24) == 0.
    ret                     ; Return to caller.

; == wait_usec ==
; Treats r24 as a 8-bit value K.
; Causes a delay almost equal to K usec.
; MODIFIES: r24, r25.
wait_usec:
    sbiw r24, 1
    nop
    nop
    nop
    nop
    brne wait_usec
    ret



