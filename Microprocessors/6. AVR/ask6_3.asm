.include "m16def.inc"

.def dirk = r17

.org 0x0
rjmp BEGIN
.org 0x2
rjmp ISR0
.org 0x10
rjmp ISR_TIMER1_OVF

BEGIN:
ldi r24,low(RAMEND)			;initialize stack
out SPL,r24
ldi r24,high(RAMEND)
out SPH,r24
ldi r24,(1<<ISC01) | (1<<ISC00)
out MCUCR, r24
ldi r24,(1<<INT0)
out GICR,r24
sei							;enable 0-interrupts, disable all rest
ldi r16,0x80
out DDRA,r16				;PA07 as input
ldi r16,0xff				;all of PORTB as output
out DDRB,r16
ldi dirk,0x00				;dirk is a guard!
LOOPA:
in r16,PINA					;check PA07...
sbrc r16,7
rjmp INIT3					;when it's set, serve
rjmp LOOPA					;rest of the time, keep waiting
INIT3:
ldi r24, (1 << TOIE1)		;enable timer interrupts
out TIMSK, r24
ldi r24, (1<<CS12) | (1<<CS11) | (1<<CS10)
out TCCR1B,r24
ldi r24,0xC2
out TCNT1H,r24				;0xC2F7 gives us 2 seconds till overflow
ldi r24,0xf7
out TCNT1L,r24
ldi r24,0x00				;initialize r24 for the check...
cpi dirk, 0x00				;was that the first press?
breq NOTALL3
ldi r24,0xfe				;lockn'load r24...
NOTALL3:
inc r24
out PORTB,r24				;light PB00 (or all of PORTB) up!
cpi dirk,0					;check guard again
brne ALLA3
inc dirk
rjmp LOOPA
ALLA3:					;
ldi r24, low(2)
ldi r25, high(2)			; == 500 msec
rcall wait_msec				
ldi r24,0x01				;if we have to wait, do it and then
out PORTB,r24				;kill all except PB00
rjmp LOOPA
;======================================================================================

ISR_TIMER1_OVF:
in r26,SREG
push r26
ldi dirk, 0x00				;reinitialize guard!
ldi r26,0x00
out PORTB, r26				;kill the LEDs
pop r26
out SREG, r26
reti

;======================================================================================

ISR0:
in r26,SREG
push r26
push r25
push r24
BOUNCE:
ldi r24,(1<<INTF0)			;handle bouncing
out GIFR,r24
ldi r24, low(2)				;wait for 5 msec...
ldi r25, high(2)			
rcall wait_msec
in r24,GIFR					;check bit 6 of GIFR
sbrc r24,6					;do the same, till the bit is clear
rjmp BOUNCE
INIT2:
ldi r24, (1 << TOIE1)		;enable timer interrupts
out TIMSK, r24
ldi r24, (1<<CS12) | (1<<CS11) | (1<<CS10)
out TCCR1B,r24
ldi r24,0xC2
out TCNT1H,r24				;0xC2F7 gives us 2 seconds till overflow
ldi r24,0xf7
out TCNT1L,r24
ldi r24,0x00				;initialize r24 for the check...
cpi dirk, 0x00				;was that the first press?
breq NOTALL2
ldi r24,0xfe				;lockn'load r24...
NOTALL2:
inc r24
out PORTB,r24				;light PB00 (or all of PORTB) up!
cpi dirk,0					;check guard again
brne ALLA2
inc dirk
rjmp GBACK
ALLA2:					;
ldi r24, low(2)
ldi r25, high(2)			; == 500 msec
rcall wait_msec				
ldi r24,0x01				;if we have to wait, do it and then
out PORTB,r24				;kill all except PB00
GBACK:
pop r24
pop r25
pop r26
out SREG,r26
reti

;======================================================================================

wait_msec:
push r24
push r25
ldi r24,low(2)
ldi r25,high(2)
rcall wait_usec
pop r25
pop r24
sbiw r24,1
brne wait_msec
ret

;======================================================================================

wait_usec:
sbiw r24,1
nop
nop
nop
nop
brne wait_usec
ret

;======================================================================================
