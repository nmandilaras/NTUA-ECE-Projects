/*
 * _6.asm
 *
 *  Created: 11/27/2015 7:00:37 PM
 *   Author: Abdul
 */ 


.include "m16def.inc"


; arxikopoihsh diakophs
.org 0x0 
rjmp reset 
.org 0x4									; h INT1
rjmp ISR1									; orizetai sto 0x4

; orisma metablhtwn
.def status = r16
.def min    = r17
.def max    = r18
.def check  = r19
.def counter= r20
.def inter  = r21
RESET:
    ldi status, low(RAMEND)					; Initialize stack pointer.
    out SPL, status							; ...
    ldi status, high(RAMEND)				; ...
    out SPH, status						    ; ...

; upoloipes arxikopoihseis thirwn
	ldi r24 ,( 1 << ISC11) | ( 1 << ISC10)  ; ????eta? ? d?a??p? INT0 ?a
	out MCUCR , r24						    ; p???a?e?ta? µe s?µa ?et???? a?µ??
	ldi r24 ,( 1 << INT1)					; ??e???p???se t? d?a??p? INT0
	out GICR , r24
	sei										; ??e???p???se t?? s???????? d?a??p??
; arxikopoiseis eiswdwn eksodwn
    clr status            
    out DDRD, status					    ; PORTD as input. 
    ser status                
    out DDRB, status						; PORTB as output.
    ser status                
    out DDRA, status						; PORTA as output for counter of INT0.
	clr inter								; set interrupt counter=0
	clr counter								; initialize counter = 0

LOOP:
	out PORTB,counter						; show counter on portB
	ldi r24, low(200)
    ldi r25, high(200)
    rcall wait_msec							; Delay for 200msec.
	inc counter
	rjmp LOOP

ISR1:
	push counter							; save counter
	in counter,SREG							; and SREG
	push counter
	ser counter								; these led output

	in status,PIND							; read frop pinD
	sbrs status,7
	rjmp TELOS

	inc inter								; increase interruptions counter
	out PORTA,inter							; and print it in A leds
;	rcall wait_msec							; Delay for 200msec.

TELOS:
	pop counter
	out SREG,counter
	pop counter
	sei
	ret


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


