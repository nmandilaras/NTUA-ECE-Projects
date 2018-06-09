.include "m16def.inc"

.def temp = r16
.def ok = r17
.def breaking = r18
.def t_high = r19
.def t_low = r20

.org 0x00
rjmp setup

.org 0x10
rjmp timer_overflow_routine

setup:

ldi temp, low(RAMEND)
out SPL,temp
ldi temp, high(RAMEND)
out SPH, temp

ldi temp,0x00
out DDRA, temp
ldi temp, 0xFF
out DDRB,temp
ldi temp, 0x00 
out PORTB, temp 
ldi temp,0xFC /* output to LCD screen: D7-D2*/
out DDRD,temp
ldi temp,0xF0 /*output to keyboard: C7-C4*/
out DDRC,temp

ldi temp,0x04 /*also setting on timer interrupt*/
out TIMSK,temp
ldi temp, 0x00
out TCCR1B, temp /*initially timer is set off*/


START:
	ldi ok,0
	ldi breaking,0
	rcall lcd_init
	sei
READING:
	in temp,PINA
	cpi temp,0
	breq READING
	ldi r24,0x0E
	rcall lcd_command
	ldi r24,39
	ldi r25,0
	rcall wait_usec
	ldi temp,0x67
	out TCNT1H,temp
	ldi temp,0x69
	out TCNT1L,temp
	ldi temp,0x05
	out TCCR1B,temp
FIRST:
	ldi r24,20
	rcall scan_keypad_rising_edge
	rcall keypad_to_ascii
	cpi r24,0
	breq FIRST
	push r24
	rcall lcd_data
	pop r24
	mov temp,r24
	cpi temp,'0'
	brne FIRST
SECOND:	
	ldi r24,20
	rcall scan_keypad_rising_edge
	rcall keypad_to_ascii
	cpi r24,0
	breq SECOND

	push r24
	rcall lcd_data
	pop r24
	mov temp,r24
	cpi temp,'0'
	breq SECOND
	mov temp,r24
	cpi temp,'5'
	brne FIRST
THIRD:
	ldi r24,20
	rcall scan_keypad_rising_edge
	rcall keypad_to_ascii
	cpi r24,0
	breq THIRD
	mov temp,r24
	push r24
	rcall lcd_data
	pop r24
	mov temp,r24
	cpi temp,'C'
	brne FIRST	
	ldi ok,1
	cpi breaking,0
	brne ALREADY_RINGS
	rcall alarm_off
ALREADY_RINGS:
	rjmp ALREADY_RINGS
	/*telos*/




alarm_off:
	ldi r24,0x0C
	rcall lcd_command
	ldi r24,39
	ldi r25,0
	rcall wait_usec
	ldi r24,0x01
	rcall lcd_command
	ldi r24,low(1530)
	ldi r25,high(1530)
	rcall wait_usec
	ldi r24,0x41
	rcall lcd_data
	ldi r24,0x4C
	rcall lcd_data
	ldi r24,0x41
	rcall lcd_data
	ldi r24,0x52
	rcall lcd_data
	ldi r24,0x4D
	rcall lcd_data
	ldi r24,0x20
	rcall lcd_data
	ldi r24,0x4F
	rcall lcd_data
	ldi r24,0x46
	rcall lcd_data
	ldi r24,0x46
	rcall lcd_data
ENDING:
	
	rjmp ENDING
	ret

alarm_on:
	ldi r24,0x0C
	rcall lcd_command
	ldi r24,39
	ldi r25,0
	rcall wait_usec
	ldi r24,0x01
	rcall lcd_command
	ldi r24,low(1530)
	ldi r25,high(1530)
	rcall wait_usec
	ldi r24,0x41
	rcall lcd_data
	ldi r24,0x4C
	rcall lcd_data
	ldi r24,0x41
	rcall lcd_data
	ldi r24,0x52
	rcall lcd_data
	ldi r24,0x4D
	rcall lcd_data
	ldi r24,0x20
	rcall lcd_data
	ldi r24,0x4F
	rcall lcd_data
	ldi r24,0x4E
	rcall lcd_data
SHOW:
	ser temp
	out PORTB,temp
	ldi r24,low(200)
	ldi r25,high(200)
	rcall wait_msec
	clr temp
	out PORTB,temp
	ldi r24,low(200)
	ldi r25,high(200)
	rcall wait_msec
	rjmp SHOW
	ret

timer_overflow_routine:
	ldi r24,20
	ldi r25,0
	rcall wait_msec
	cpi ok,0
	brne PASSWORD_CORRECT
	ldi breaking,1
	rcall alarm_on
PASSWORD_CORRECT:
	reti

/*------------------------------------*/
/*             FUNCTIONS              */
/*------------------------------------*/

keypad_to_ascii: /*logic 1 in r26 register means pressed buttons in rows 3-4*/
movw r26 ,r24 ; /*pressed button depends on position of 1*/
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
sbrc r26 ,3 /*if the button was found, function returns its ASCII*/
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
ldi r24 ,'4' /*the two other rows are displayed at r27*/
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

scan_keypad_rising_edge:
mov r22 ,r24 /*r22: stabilization time*/
rcall scan_keypad /*first scan*/
push r24 /*we will wait for the voltage values to stabilize*/
push r25
mov r24 ,r22 
ldi r25 ,0 
rcall wait_msec
rcall scan_keypad /*second scan*/
pop r23 /*r25:r24 has the new values*/
pop r22 /*r23:r22 the old ones*/
and r24 ,r22 /*this is useful to abort keys whose voltage has reverted*/
and r25 ,r23
mov r22 ,t_low /*t_low, t_high pair continuously stores (at previous runs) values*/
mov r23 ,t_high 
mov t_low ,r24 
mov t_high ,r25
com r23 /*inversion, so that (now we have avoided potential problems)*/
com r22 /*we will find the just-pressed buttons*/
and r24 ,r22 /*these keys will be saved on r24-r25 pair*/
and r25 ,r23
ret

scan_keypad:
ldi r24 ,0x01 /*first line scanned*/ 
rcall scan_row
swap r24 /*Swapping the 2 hexes so that the result*/
mov r27 ,r24  /*will be set at r27 msbs*/
ldi r24 ,0x02 /*second line*/ 
rcall scan_row
add r27 ,r24 /*result stored at 4 lsbs of r27*/
ldi r24 ,0x03 /*third line...*/
rcall scan_row
swap r24 
mov r26 ,r24 /*4 msbs of r26*/
ldi r24 ,0x04  /*fourth line..., 4 lsbs of r26*/
rcall scan_row
add r26 ,r24 
movw r24 ,r26 /*final result will return to main via r25:r24*/
ret

scan_row:
ldi r25 ,0x08 /*initialization*/
back_: lsl r25 /*left shift depending on number of row*/
dec r24  
brne back_
out PORTC ,r25 
nop
nop 
in r24 ,PINC /*pressed columns on that row return on bits c3-c0*/
andi r24 ,0x0f 
ret

wait_msec:
push r24
push r25
ldi r24,low(998)
ldi r25,high(998)
rcall wait_usec
pop r25
pop r24
sbiw r24,1
brne wait_msec
ret

wait_usec:
sbiw r24,1
nop
nop
nop
nop
brne wait_usec
ret

write_2_nibbles:
push r24
in r25 ,PIND
andi r25 ,0x0F
andi r24 ,0xF0
add r24 ,r25
out PORTD, r24
sbi PORTD,PD3
cbi PORTD,PD3
pop r24
swap r24
andi r24 ,0xF0
add r24 ,r25
out PORTD ,r24
sbi PORTD ,PD3
cbi PORTD ,PD3
ret

lcd_data:
sbi PORTD,PD2
rcall write_2_nibbles
ldi r24 ,43
ldi r25 ,0
rcall wait_usec
ret

lcd_command: 
cbi PORTD,PD2
rcall write_2_nibbles
ldi r24 ,39
ldi r25 ,0
rcall wait_usec
ret


lcd_init:
ldi r24 ,40
ldi r25 ,0
rcall wait_msec

ldi r24 ,0x30
out PORTD ,r24
sbi PORTD,PD3
cbi PORTD,PD3
ldi r24 ,39
ldi r25 ,0
rcall wait_usec
ldi r24 ,0x30
out PORTD ,r24
sbi PORTD ,PD3
cbi PORTD ,PD3
ldi r24 ,39
ldi r25 ,0
rcall wait_usec
ldi r24 ,0x20
out PORTD ,r24
sbi PORTD ,PD3
cbi PORTD ,PD3
ldi r24 ,39
ldi r25 ,0
rcall wait_usec
ldi r24 ,0x28
rcall lcd_command
ldi r24 ,0x0c
rcall lcd_command
ldi r24 ,0x01
rcall lcd_command
ldi r24 ,low(1530)
ldi r25 ,high(1530)
rcall wait_usec
ldi r24 ,0x06
rcall lcd_command
ret
