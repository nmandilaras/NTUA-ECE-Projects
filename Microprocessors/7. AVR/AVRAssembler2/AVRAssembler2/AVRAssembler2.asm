.include "m16def.inc"

    ldi r24,low(RAMEND) ;initialize stack pointer
    out spl,r24
    ldi r24,high(RAMEND)
    out sph,r24
    clr r17            
    out DDRA, r17   ; PORTA as input. 
    clr r17            
    out DDRC, r17   ; PORTC as input. 
	ser r26         ; αρχικοποίηση της PORTΒ
    out DDRB , r26  ; για έξοδο

flash:
	in r17,PINA	    ; input in r17
	in r22,PINC	    ; input in r22	 
	ldi r20 , 0X04  ; counter
LOOPA:	
    ldi r18,0X00
	lsr r17         ; shift right 
	in r16,sreg
	andi r16, 0x01  ; mask C flag
	lsr r17         ; shift right
	in r19,sreg
	andi r19, 0x01  ; mask C flag
	;lsr r22
	;in r23,sreg
	;andi r23, 0x01 
	dec r20
	cpi r20, 0x03
	breq T1
	cpi r20, 0x02
	breq T2
	cpi r20, 0x01
	breq T3
	cpi r20, 0x00
	breq T4

T1:
	cp  r16,r19     ; Compare r16 to r19
    breq C01        ; Branch if r16==r19
	inc r18
C01: 
    mov r21,r18
	rjmp LOOPA

T2:
   cpi r16,0x01
   brne C02
   inc r18
   rjmp C03
C02: 
   cpi r19,0x01
   brne C03
   inc r18
C03:
    mov r16,r18
	sbrc r22,1       ; check for C input
	rcall _reverse_   ; reverse
	lsl r18 
    and r16,r21
	mov r14,r18      ; temp values in order to 
	mov r18,r16      ; be compatible with _reverse_
	sbrc r22,0
	rcall _reverse_
	mov r16,r18      ; undo changes
	mov r18,r14
	sbrc r16,0 
	inc r18
    mov r21, r18
	rjmp LOOPA

T3:
   cpi r16,0x01
   brne C04
   inc r18
   rjmp C05
C04: 
   cpi r19,0x01
   brne C05
   inc r18
C05:
   com r18
   andi r18, 0x01
   sbrc r22,2       ; check for C input
   rcall _reverse_   ; reserve
   lsl r18
   lsl r18
   add r21,r18
   rjmp LOOPA

T4:
	cp  r16,r19     ; Compare r16 to r19
    brne C06        ; Branch if r16!=r19
	inc r18
C06:
	sbrc r22,3      ; check for C input
	rcall _reverse_  ; reserve
    lsl r18
	lsl r18
	lsl r18
    add r21,r18
	andi r22, 0xf0
	add r21,r22
    out PORTB , r21
	rjmp flash


_reverse_:
   com r18
   andi r18, 0x01
   reti