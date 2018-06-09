.include "m16def.inc"
.DSEG
_tmp_: .byte 2
.CSEG

.org 0x0000
rjmp main

main:

	;initialize stack pointer
	ldi r24 , low(RAMEND) 
	out SPL , r24
	ldi r24 , high(RAMEND)  
	out SPH , r24

	ldi r24, 0x14                   ; 20 msec bouncing time
    rcall scan_keyboard_rising_edge ; just so we can have a reference

	ldi r24, 0xf0 	; 4 MSB  of PORTC
 	out DDRC, r24 	; are set as output
                    ; this is done in order to use the keypad

	; Initialize for output in order
	; to use LCD screen
	ser r24
	out DDRD, r24

	rcall lcd_init	; initialize lcd
	ldi r24, 'N'	; print "NONE"
	rcall lcd_data
	ldi r24, 'O'	 
	rcall lcd_data
	ldi r24, 'N'	 
	rcall lcd_data
	ldi r24, 'E'	 
	rcall lcd_data

start:    
	;ldi r24, low(2)
	;ldi r25, high(2)
	;rcall wait_msec
	ldi r24, 0x14	; 20msec bouncing time
    rcall scan_keyboard_rising_edge
    rcall keyboard_to_ascii
	push r24
	cpi r24, 0x00
	breq start
	
	rcall lcd_init	; erase "NONE"
	pop r24
	rcall lcd_data
	rjmp start


;**************SCAN_ROW****************
scan_row:
; Input: r24 the line which we want to read
; Output: r24 which buttons are pressed
; Uses: r24, r25

	ldi r25 ,0x08 	; Initialize with 0000 10000
back_:
	lsl r25 		; left shift of '1' the same
	dec r24 		; as the number of the row
 	brne back_
	out PORTC ,r25 	; the apropriate line is set to 1
	nop
	nop 			; wait for the change to take effect
	in r24 ,PINC 	; return collumns of pressed buttons
	andi r24 ,0x0f 	; keep the 4 LSB where '1' shows pressed
	ret 			; buttons.


;*************SCAN_KEYPAD**************
scan_keypad:
; Input: none
; Output: r25:r24 which buttons are pressed
; Uses: r27:r26, r25:r24
	
	ldi r24 ,0x01 	; Check the first line of the keypad
 	rcall scan_row
	swap r24 		; Store the result
	mov r27 ,r24 	; at the 4 MSB of r27
	ldi r24 ,0x02 	; Check the second line of the keypad
	rcall scan_row
	add r27 ,r24 	; Store the result at the 4 LSB of r27
 	ldi r24 ,0x03 	; Check the third line of the keypad
 	rcall scan_row
	swap r24 		; store the result
	mov r26 ,r24 	; at the 4 MSB of r26
	ldi r24 ,0x04 	; Check the fourth line of the keypad
	rcall scan_row
	add r26 ,r24 	; Store the result at the 4 LSB of r26
	movw r24 ,r26 	; move the result to the registers r25:r24
	ret


;*******SCAN_KEYBOARD_RISING_EDGE*******
scan_keyboard_rising_edge:
; Input: r24 bouncing time
; Output: r25:r24 Buttons that weren't pressed last time it was called
; Uses: r27:r26, r25:r25, r23:r22

	mov r22 ,r24 		; store bouncing time to r22
	rcall scan_keypad 	; check keyboard for pressed buttons
	push r24 			; and store the result
	push r25
	mov r24 ,r22 		; stall r22 ms (typical values 10-20 msec which is specified
	ldi r25 ,0 			; by the keyboard maker - bouncing duration)
	rcall wait_msec
	rcall scan_keypad 	; Check the keyboard again
	pop r23 			; remove the buttons that bounce
	pop r22 			
	and r24 ,r22
	and r25 ,r23
	ldi r26 ,low(_tmp_) ; load the state of buttons
	ldi r27 ,high(_tmp_) ; from the previous call to r27:r26
 	ld r23 ,X+
	ld r22 ,X
	st X ,r24 			; store the new state of the buttons
	st -X ,r25 			; in the RAM
	com r23
	com r22 			; find the buttons that have just been pressed
	and r24 ,r22
	and r25 ,r23
	ret	

;************KEYBOARD_TO_ASCII*********
keyboard_to_ascii:
; Input: r25:r24 shows which buttons are pressed
; Output: r24 the ascii character that has been pressed or 0 if no button pressed
; Uses: r27:r26, r25:r24
	movw r26, r24 		; move input to r26:r25
	ldi r24, '*'		; in r26 are these symbols
	sbrc r26, 0			; C 9 8 7 D # 0 *
	ret
	ldi r24, '0'
	sbrc r26, 1
	ret
	ldi r24, '#'
	sbrc r26, 2
	ret
	ldi r24, 'D'
	sbrc r26, 3 		; if not '1' ignores ret, otherwise
	ret 				; returns with r24 set to D.
	ldi r24, '7'
	sbrc r26, 4
	ret
	ldi r24, '8'
	sbrc r26, 5
	ret
	ldi r24, '9'
	sbrc r26, 6
	ret
	ldi r24, 'C'
	sbrc r26, 7
 	ret
 	ldi r24, '4' 		; logical '1' in these places of r27 suggest that there
	sbrc r27, 0 		; are A 3 2 1 B 6 5 4
	ret
	ldi r24, '5'
	sbrc r27, 1
	ret
	ldi r24, '6'
	sbrc r27, 2
	ret
	ldi r24, 'B'
	sbrc r27, 3
	ret
	ldi r24, '1'
	sbrc r27, 4
	ret
	ldi r24, '2'
	sbrc r27, 5
	ret
	ldi r24, '3'
	sbrc r27, 6
	ret
	ldi r24, 'A'
	sbrc r27, 7
	ret
	clr r24
 	ret

;**************wait_usec***************
wait_usec:
	sbiw r24 ,1 		;2 cycles (0.250 usec)
	nop			;1 cycle (0.125 usec)
	nop			;1 cycle (0.125 usec)
	nop			;1 cycle (0.125 usec)
	nop			;1 cycle (0.125 usec)
	brne wait_usec 		;1 or 2 cycles
	ret			;4 cycles(0.500usec)

;*************wait_msec****************
wait_msec:
	push r24		;2 cycles
	push r25		;2 cycles
	ldi r24 , low(998) 		;(1 cycle-0.125sec)
	ldi r25 , high(998)	;1 cycle
	rcall wait_usec 		;3 cycles(0.375usec) total 998.375usec
	pop r25			;2 cycles
	pop r24			;2 cycles
	sbiw r24 , 1 		;2cycles
	brne wait_msec 		;1 or 2 cycles
	ret			;4 cycles



; send byte to the lcd controller, 4 bits at a time to the lcd controller
; RS not affected
; Input: byte to send, in R24
; Output: -
; Registers: r24:r25
write_2_nibbles: 
	push r24			; sends 4 MSBs
	in r25 ,PIND 		; 4 LSBs read and resent
	andi r25 ,0x0f 		; isolate the 4 MSBs and 	
	andi r24 ,0xf0 		; and compbine them with the 
	add r24 ,r25		; four LSBs
	out PORTD ,r24 		; send to exit
	sbi PORTD ,PD3 		; enable pulse in PD3
	cbi PORTD ,PD3 		; PD3 = 1 and then PD3 = 0
	pop r24				; send 4 LSBs. Regain byte
	swap r24			; exchange 4 MSBs with 4 LSBs
	andi r24 ,0xf0 		; send 4 LSBs
	add r24 ,r25
	out PORTD ,r24 
	sbi PORTD ,PD3 		; new enable pulse
	cbi PORTD ,PD3 
	ret

; send data byte to the lcd controller
; the controller must operate in 4-bit mode
; Input: byte in r24
; Registers: r25:r24
lcd_data:
	sbi PORTD ,PD2		; we choose the data register (PD2 = 1)
	rcall write_2_nibbles ; send byte
	ldi r24 ,43			; wait 43ms until data is received
	ldi r25 ,0			; from lcd controller
	rcall wait_usec
	ret

; send instruction to lcd conroller
; the controller must operate in 4-bit mode
; Input: instruction stored in r24
; Output: -
; Registers: r24-r25
lcd_command:
	cbi PORTD ,PD2		; choice of instruction register (PD2 = 1)
	rcall write_2_nibbles ; send the instruction and wait 39ms
	ldi r24 ,39			; for it to be sent and executed
	ldi r25 ,0			; by the lcd controller
	rcall wait_usec
	ret

; Initialization and settings of the lcd display:
; DL = 0 (4-bit mode)
; N = 1 (2 lines)
; F = 0 (5x8 dots)
; D = 1 (display on)
; C = 0 (cursor off)
; B = 0 (blinking off)
; I/D = 1 (DDRAM address auto increment)
; SH = 0 (shift of entire display off)
lcd_init:
	ldi r24 ,40			; whan lcd controller gets powered it executes
	ldi r25 ,0			; its own initialization
	rcall wait_msec		; we wait 40ms until it is over
	ldi r24 ,0x30		; we turn on 8-bit mode
	out PORTD ,r24 		; and because we can't be sure for the input configuration,
	sbi PORTD ,PD3 		; we execute the command twice
	cbi PORTD ,PD3 
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
	ldi r24 ,0x20		; switch to 4-bit mode
	out PORTD ,r24 
	sbi PORTD ,PD3 
	cbi PORTD ,PD3 
	ldi r24 ,39
	ldi r25 ,0
	rcall wait_usec
	
	ldi r24 ,0x28		; choose 5x8 dots characters
	rcall lcd_command	; and show 2 lines on the lcd display
	
	ldi r24 ,0x0c		; activate display, hide cursor
	rcall lcd_command
	
	ldi r24 ,0x01		; clear display
	rcall lcd_command 
	ldi r24 ,low(1530) 
	ldi r25 ,high(1530) 
	rcall wait_usec
	ldi r24 ,0x06		; auto increment of the  
	rcall lcd_command	; address counter and turn off entire display shift
	ret
