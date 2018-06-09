.include "m16def.inc"
ldi r24,low(RAMEND) ;initialize stack pointer
out spl,r24
ldi r24,high(RAMEND)
out sph,r24
clr r17            ; αρχικοποίηση της PORTB   
out DDRB , r17     ; για είσοδο
ser r26            ; αρχικοποίηση της PORTA
out DDRA , r26     ; για έξοδο
flash: 
  in r17,PINB
  mov r16,r17
  andi r16,0x0f ; mask for 4 LSB
  andi r17,0xf0 ;mask for 4 MSB
  mov r15,r17
  lsr r15       ;or swap r15
  lsr r15
  lsr r15
  lsr r15
  add r15,r15
  inc r15
  add r16,r16
  inc r16

  rcall on         ; ’ναψε τα LEDs
  rcall off          ; Σβήσε τα LEDs
  rjmp flash         ; Επανέλαβε
                   ; Υπορουτίνα για να ανάβουν τα LEDs
on: 
 ldi r20,50
 mul r15,r20
 mov r24 ,r0
 mov r25 ,r1
 ser r26        ; θέσε τη θύρα εξόδου των LED
 out PORTA , r26
 rcall wait_msec
 ret                ; Γύρισε στο κύριο πρόγραμμα
                   ; Υπορουτίνα για να σβήνουν τα LEDs
off: 
 mul r16,r20
 mov r24 ,r0
 mov r25 ,r1
 clr r26       ; μηδένισε τη θύρα εξόδου των LED
 out PORTA , r26
 rcall wait_msec
 ret                ; Γύρισε στο κύριο πρόγραμμα

wait_usec:
sbiw r24 ,1 ; 2 κύκλοι (0.250 μsec)
nop ; 1 κύκλος (0.125 μsec)
nop ; 1 κύκλος (0.125 μsec)
nop ; 1 κύκλος (0.125 μsec)
nop ; 1 κύκλος (0.125 μsec)
brne wait_usec ; 1 ή 2 κύκλοι (0.125 ή 0.250 μsec)
ret 

wait_msec:
 push r24 ; 2 κύκλοι (0.250 μsec)
 push r25 ; 2 κύκλοι
 ldi r24 , low(998) ; φόρτωσε τον καταχ. r25:r24 με 998 (1 κύκλος - 0.125 μsec)
 ldi r25 , high(998) ; 1 κύκλος (0.125 μsec)
 rcall wait_usec ; 3 κύκλοι (0.375 μsec), προκαλεί συνολικά καθυστέρηση 998.375 μsec
 pop r25 ; 2 κύκλοι (0.250 μsec)
 pop r24 ; 2 κύκλοι
 sbiw r24 , 1 ; 2 κύκλοι
 brne wait_msec ; 1 ή 2 κύκλοι (0.125 ή 0.250 μsec)
 ret ; 4 κύκλοι (0.500 μsec)

