.include "m16def.inc"

    ldi r24,low(RAMEND) ;initialize stack pointer
    out spl,r24
    ldi r24,high(RAMEND)
    out sph,r24
    clr r17            
    out DDRB, r17   ; PORTB as input. 
    ser r26         ; αρχικοποίηση της PORTΒ
    out DDRA , r26  ; για έξοδο
    ldi r17, 0xfc
    out DDRD, r17 ; PD2-7 as output (LCD screen).
    rcall lcd_init ; Initialize LCD screen.

flash:
   rcall wipe_screen ; Perform screen wipe.
   in r17,PINB	    ; input in r17
  ; push r17      ; Save input number on stack. ; xreiazetai ??

   ldi r24,'1'
   sbrs r17,7    ; Skip if bit 7 in r17 is set
   ldi r24,'0'
   rcall lcd_data
   ldi r24,'1'
   sbrs r17,6
   ldi r24,'0'
   rcall lcd_data
   ldi r24,'1'
   sbrs r17,5
   ldi r24,'0'
   rcall lcd_data
   ldi r24,'1'
   sbrs r17,4
   ldi r24,'0'
   rcall lcd_data
   ldi r24,'1'
   sbrs r17,3
   ldi r24,'0'
   rcall lcd_data
   ldi r24,'1'
   sbrs r17,2
   ldi r24,'0'
   rcall lcd_data
   ldi r24,'1'
   sbrs r17,1
   ldi r24,'0'
   rcall lcd_data
   ldi r24,'1'
   sbrs r17,0
   ldi r24,'0'
   rcall lcd_data
   ldi r24,'='
   rcall lcd_data
   ldi r24,'+'	
   sbrc r17,7      ; Skip if bit 7 in r17 cleared
   rcall _complement_
   rcall lcd_data
   ldi r18,0       ; initialize hundrens
   ldi r19,0       ; initialize decades
                    ; BCD



tag1:
    cpi r17,100
	brlo tag2
	subi r17,100
	ldi r18,1
 tag2:
    cpi r17,10
	brlo tag3
	subi r17,10
	inc  r19
	rjmp tag2
tag3:
    ldi r16,48
    add r18,r16
	add r19,r16
	add r17,r16 
    mov r24, r18
	cpi r24, 48       ; if it is zero don't print it
	breq tag4
    rcall lcd_data     
	mov r24 , r19
    rcall lcd_data 
	rjmp tag5
tag4:
    mov r24 , r19
	cpi r24, 48       ; if it is zero don't print it
	breq tag5
    rcall lcd_data
tag5:
    mov r24 , r17
	rcall lcd_data
    rjmp flash

_complement_:       ; two's complement
    com r17
	inc r17
	ldi r24,'-'
	ret

lcd_init:
  ldi r24 ,40 ; Όταν ο ελεγκτής της lcd τροφοδοτείται με
  ldi r25 ,0 ; ρεύμα εκτελεί την δική του αρχικοποίηση.
  rcall wait_msec ; Αναμονή 40 msec μέχρι αυτή να ολοκληρωθεί.
  ldi r24 ,0x30 ; εντολή μετάβασης σε 8 bit mode
  out PORTD ,r24 ; επειδή δεν μπορούμε να είμαστε βέβαιοι
  sbi PORTD ,PD3 ; για τη διαμόρφωση εισόδου του ελεγκτή
  cbi PORTD ,PD3 ; της οθόνης, η εντολή αποστέλλεται δύο φορές
  ldi r24 ,39
  ldi r25 ,0 ; εάν ο ελεγκτής της οθόνης βρίσκεται σε 8-bit mode
  rcall wait_usec ; δεν θα συμβεί τίποτα, αλλά αν ο ελεγκτής έχει διαμόρφωση
                  ; εισόδου 4 bit θα μεταβεί σε διαμόρφωση 8 bit
  ldi r24 ,0x30
  out PORTD ,r24
  sbi PORTD ,PD3
  cbi PORTD ,PD3
  ldi r24 ,39
  ldi r25 ,0
  rcall wait_usec

 ldi r24 ,0x20 ; αλλαγή σε 4-bit mode
 out PORTD ,r24
 sbi PORTD ,PD3
 cbi PORTD ,PD3
 ldi r24 ,39
 ldi r25 ,0
 rcall wait_usec

 ldi r24 ,0x28 ; επιλογή χαρακτήρων μεγέθους 5x8 κουκίδων
 rcall lcd_command ; και εμφάνιση δύο γραμμών στην οθόνη
 ldi r24 ,0x0c ; ενεργοποίηση της οθόνης, απόκρυψη του κέρσορα
 rcall lcd_command
 ldi r24 ,0x01 ; καθαρισμός της οθόνης
 rcall lcd_command
 ldi r24 ,low(1530)
 ldi r25 ,high(1530)
 rcall wait_usec

 ldi r24 ,0x06 ; ενεργοποίηση αυτόματης αύξησης κατά 1 της διεύθυνσης
 rcall lcd_command ; που είναι αποθηκευμένη στον μετρητή διευθύνσεων και
                   ; απενεργοποίηση της ολίσθησης ολόκληρης της οθόνης
 ret
lcd_command:
  cbi PORTD ,PD2 ; επιλογή του καταχωρητή εντολών (PD2=0)
  rcall write_2_nibbles ; αποστολή της εντολής και αναμονή 39μsec
  ldi r24 ,39 ; για την ολοκλήρωση της εκτέλεσης της από τον ελεγκτή της lcd.
  ldi r25 ,0 ; ΣΗΜ.: υπάρχουν δύο εντολές, οι clear display και return home,
  rcall wait_usec ; που απαιτούν σημαντικά μεγαλύτερο χρονικό διάστημα.
  ret

lcd_data:
 sbi PORTD ,PD2 ; επιλογή του καταχωρήτη δεδομένων (PD2=1)
 rcall write_2_nibbles ; αποστολή του byte
 ldi r24 ,43 ; αναμονή 43μsec μέχρι να ολοκληρωθεί η λήψη
 ldi r25 ,0 ; των δεδομένων από τον ελεγκτή της lcd
 rcall wait_usec
 ret

write_2_nibbles:
  push r24 ; στέλνει τα 4 MSB
  in r25 ,PIND ; διαβάζονται τα 4 LSB και τα ξαναστέλνουμε
  andi r25 ,0x0f ; για να μην χαλάσουμε την όποια προηγούμενη κατάσταση
  andi r24 ,0xf0 ; απομονώνονται τα 4 MSB και
  add r24 ,r25 ; συνδυάζονται με τα προϋπάρχοντα 4 LSB
  out PORTD ,r24 ; και δίνονται στην έξοδο
  sbi PORTD ,PD3 ; δημιουργείται παλμός Εnable στον ακροδέκτη PD3
  cbi PORTD ,PD3 ; PD3=1 και μετά PD3=0
  pop r24 ; στέλνει τα 4 LSB. Ανακτάται το byte.
  swap r24 ; εναλλάσσονται τα 4 MSB με τα 4 LSB
  andi r24 ,0xf0 ; που με την σειρά τους αποστέλλονται
  add r24 ,r25
  out PORTD ,r24
  sbi PORTD ,PD3 ; Νέος παλμός Εnable
  cbi PORTD ,PD3
  ret

; == wipe_screen ==
; Wipes the LCD screen. Assumes screen controller has initialized correctly.
; Note: Approx. 1.5sec delay caused as a result of command processing.
; MODIFIES: r24, r25
wipe_screen:
  ldi r24, 0x01 ; Issue a screen-wipe command.
  rcall lcd_command ;
  ldi r24, low(1530) ; Delay for 1.5msec until command is processed.
  ldi r25, high(1530)
  rcall wait_usec
  ret ; Return to caller.

wait_usec:
 sbiw r24 ,1 ; 2 κύκλοι (0.250 μsec)
 nop ; 1 κύκλος (0.125 μsec)
 nop ; 1 κύκλος (0.125 μsec)
 nop ; 1 κύκλος (0.125 μsec)
 nop ; 1 κύκλος (0.125 μsec)
 brne wait_usec ; 1 ή 2 κύκλοι (0.125 ή 0.250 μsec)
 ret ; 4 κύκλοι (0.500 μsec)

wait_msec:
 push r24 ; 2 κύκλοι (0.250 μsec)
 push r25 ; 2 κύκλοι
 ldi r24 , low(998) ; φόρτωσε τον καταχ. r25:r24 με 998 (1 κύκλος - 0.125 μsec)
 ldi r25 , high(998) ; 1 κύκλος (0.125 μsec)
 rcall wait_usec ; 3 κύκλοι (0.375 μsec), προκαλεί συνολικά καθυστέρηση 998.375 μsec
 pop r25 ; 2 κύκλοι (0.250 μsec)
 pop r24 ; 2 κύκλοι
 sbiw r24 , 1 ; 2 κύκλοι
 brne wait_msec ; 1 ή 2 κύκλοι (0.125 ή 0.25
 ret ; 4 κύκλοι (0.500 μsec)


