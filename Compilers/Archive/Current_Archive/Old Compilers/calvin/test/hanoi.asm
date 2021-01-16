xseg	segment	byte public 'code'
	assume	cs:xseg, ds:xseg, ss:xseg
	org	100h

start:
	call	near ptr _main_7

	mov	ax,4c00h
	int	21h

@1: 
_move_11	proc	near
	push	bp
	mov	bp,sp
	sub	sp,0

@2: 
	lea	si,@@1
	push	si
@3: 
	sub	sp,2
	push	bp
	call	near ptr _PutString
	add	sp,6
@4: 
	mov	si,[bp+10]
	push	si
@5: 
	sub	sp,2
	push	bp
	call	near ptr _PutString
	add	sp,6
@6: 
	lea	si,@@2
	push	si
@7: 
	sub	sp,2
	push	bp
	call	near ptr _PutString
	add	sp,6
@8: 
	mov	si,[bp+8]
	push	si
@9: 
	sub	sp,2
	push	bp
	call	near ptr _PutString
	add	sp,6
@10: 
	lea	si,@@3
	push	si
@11: 
	sub	sp,2
	push	bp
	call	near ptr _PutString
	add	sp,6
@12: 
@move_11:
	mov	sp,bp
	pop	bp
	ret
_move_11	endp

@13: 
_hanoi_9	proc	near
	push	bp
	mov	bp,sp
	sub	sp,4

@14: 
	mov	ax,[bp+8]
	mov	dx,1
	cmp	ax,dx
	jl	@16
@15: 
	jmp	@18
@16: 
	jmp	@hanoi_9
@17: 
	jmp	@33
@18: 
	mov	si,[bp+14]
	push	si
@19: 
	mov	si,[bp+10]
	push	si
@20: 
	mov	si,[bp+12]
	push	si
@21: 
	mov	ax,[bp+8]
	mov	dx,1
	sub	ax,dx
	mov	[bp-2],ax
@22: 
	mov	ax,[bp-2]
	push	ax
@23: 
	sub	sp,2
	push	[bp+4]
	call	near ptr _hanoi_9
	add	sp,12
@24: 
	mov	si,[bp+14]
	push	si
@25: 
	mov	si,[bp+12]
	push	si
@26: 
	sub	sp,2
	push	bp
	call	near ptr _move_11
	add	sp,8
@27: 
	mov	si,[bp+10]
	push	si
@28: 
	mov	si,[bp+12]
	push	si
@29: 
	mov	si,[bp+14]
	push	si
@30: 
	mov	ax,[bp+8]
	mov	dx,1
	sub	ax,dx
	mov	[bp-4],ax
@31: 
	mov	ax,[bp-4]
	push	ax
@32: 
	sub	sp,2
	push	[bp+4]
	call	near ptr _hanoi_9
	add	sp,12
@33: 
@hanoi_9:
	mov	sp,bp
	pop	bp
	ret
_hanoi_9	endp

@34: 
_main_7	proc	near
	push	bp
	mov	bp,sp
	sub	sp,4

@35: 
	lea	si,@@4
	push	si
@36: 
	sub	sp,2
	push	bp
	call	near ptr _PutString
	add	sp,6
@37: 
	lea	si,[bp-4]
	push	si
@38: 
	push	bp
	call	near ptr _GetInteger
	add	sp,4
@39: 
	mov	ax,[bp-4]
	mov	[bp-2],ax
@40: 
	lea	si,@@5
	push	si
@41: 
	sub	sp,2
	push	bp
	call	near ptr _PutString
	add	sp,6
@42: 
	lea	si,@@6
	push	si
@43: 
	lea	si,@@7
	push	si
@44: 
	lea	si,@@8
	push	si
@45: 
	mov	ax,[bp-2]
	push	ax
@46: 
	sub	sp,2
	push	bp
	call	near ptr _hanoi_9
	add	sp,12
@47: 
@main_7:
	mov	sp,bp
	pop	bp
	ret
_main_7	endp

@@1	db	'Move from ', 0
@@2	db	' to ', 0
@@3	db	'.', 13, 10, 0
@@4	db	'Please give the number of rings: ', 0
@@5	db	13, 10, 'Here is the solution: ', 13, 10, 13, 10, 0
@@6	db	'left', 0
@@7	db	'right', 0
@@8	db	'middle', 0

	extrn	_PutChar: proc
	extrn	_PutInteger: proc
	extrn	_PutString: proc
	extrn	_GetChar: proc
	extrn	_GetInteger: proc
	extrn	_GetString: proc

xseg	ends
	end	start
