; number in r17 and units also finally, hundrends in r18, r19 decades
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



