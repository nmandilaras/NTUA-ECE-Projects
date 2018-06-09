
.include "m16def.inc"


.def status = r16
.def min    = r17
.def max    = r18
.def check  = r19

RESET:
    ldi status, low(RAMEND) ; Initialize stack pointer.
    out SPL, status         ; ...
    ldi status, high(RAMEND); ...
    out SPH, status         ; ...
    clr status            
    out DDRA, status        ; PORTA as input. 
    out PORTA, status       ; ...
    ser status                
    out DDRB, status        ; PORTB as output.
    out PORTB, status       ; Enable pull-up resistors (for LEDs).
    ldi min, 0x01           ; Rightmost position.
    ldi max, 0x80           ; Leftmost position.
    mov status, min         ; Initial state: only LED A0 is on.

WAITL:
    in check, PINA          ; Spin until PB0 is pressed. in mean read from PIN
    cp check, max        ; ...
    breq WAITL              ; ...
    out PORTB, status       ; Light LEDs.
    lsl status              ; Shift register to the left.
    ldi r24, low(500)
    ldi r25, high(500)
    rcall wait_msec         ; Delay for 500msec.
    cpse status, max        ; Break loop if leftmost bit is reached.
    rjmp WAITL
    
WAITR:
    in check, PINA          ; Spin until PB0 is pressed. in mean read from PIN
    cp check, max        ; ...
    breq WAITR              ; ...
    out PORTB, status       ; Light LEDs.
    lsr status              ; Shift register to the right.
    ldi r24, low(500)
    ldi r25, high(500)
    rcall wait_msec         ; Delay for 500msec.
    cpse status, min        ; Break loop if rightmost bit is reached. 
    rjmp WAITR
    rjmp WAITL              ; Loop endlessly...

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


