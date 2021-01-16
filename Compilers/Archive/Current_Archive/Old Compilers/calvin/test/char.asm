xseg	segment	byte public 'code'
	assume	cs:xseg, ds:xseg, ss:xseg
	org	100h

start:
	call	near ptr _main_11

	mov	ax,4c00h
	int	21h

@1: 
_swap_15	proc	near
	push	bp
	mov	bp,sp
	sub	sp,1

@2: 
	mov	si,[bp+10]
	mov	al,[si]
	mov	[bp-1],al
@3: 
	mov	si,[bp+8]
	mov	al,[si]
	mov	si,[bp+10]
	mov	[si],al
@4: 
	mov	al,[bp-1]
	mov	si,[bp+8]
	mov	[si],al
@5: 
@swap_15:
	mov	sp,bp
	pop	bp
	ret
_swap_15	endp

@6: 
_swap_string_13	proc	near
	push	bp
	mov	bp,sp
	sub	sp,20

@7: 
	mov	ax,0
	mov	[bp-2],ax
@8: 
	mov	si,[bp+10]
	push	si
@9: 
	lea	si,[bp-6]
	push	si
@10: 
	push	bp
	call	near ptr _StrLen
	add	sp,6
@11: 
	mov	ax,[bp-2]
	mov	dx,[bp-6]
	cmp	ax,dx
	jle	@13
@12: 
	jmp	@17
@13: 
	mov	di,[bp-2]
	mov	si,[bp+10]
	add	si,di
	mov	al,[si]
	mov	di,[bp-2]
	mov	si,[bp+8]
	add	si,di
	mov	[si],al
@14: 
	mov	ax,[bp-2]
	mov	dx,1
	add	ax,dx
	mov	[bp-8],ax
@15: 
	mov	ax,[bp-8]
	mov	[bp-2],ax
@16: 
	jmp	@8
@17: 
	mov	ax,0
	mov	[bp-2],ax
@18: 
	mov	si,[bp+8]
	push	si
@19: 
	lea	si,[bp-10]
	push	si
@20: 
	push	bp
	call	near ptr _StrLen
	add	sp,6
@21: 
	mov	ax,[bp-10]
	xor	dx,dx
	mov	cx,2
	idiv	cx
	mov	[bp-12],ax
@22: 
	mov	ax,[bp-2]
	mov	dx,[bp-12]
	cmp	ax,dx
	jl	@24
@23: 
	jmp	@35
@24: 
	mov	di,[bp-2]
	mov	si,[bp+8]
	add	si,di
	push	si
@25: 
	mov	si,[bp+8]
	push	si
@26: 
	lea	si,[bp-14]
	push	si
@27: 
	push	bp
	call	near ptr _StrLen
	add	sp,6
@28: 
	mov	ax,[bp-14]
	mov	dx,[bp-2]
	sub	ax,dx
	mov	[bp-16],ax
@29: 
	mov	ax,[bp-16]
	mov	dx,1
	sub	ax,dx
	mov	[bp-18],ax
@30: 
	mov	di,[bp-18]
	mov	si,[bp+8]
	add	si,di
	push	si
@31: 
	sub	sp,2
	push	bp
	call	near ptr _swap_15
	add	sp,8
@32: 
	mov	ax,[bp-2]
	mov	dx,1
	add	ax,dx
	mov	[bp-20],ax
@33: 
	mov	ax,[bp-20]
	mov	[bp-2],ax
@34: 
	jmp	@18
@35: 
@swap_string_13:
	mov	sp,bp
	pop	bp
	ret
_swap_string_13	endp

@36: 
_main_11	proc	near
	push	bp
	mov	bp,sp
	sub	sp,50

@37: 
	lea	si,@@1
	push	si
@38: 
	lea	si,[bp-50]
	push	si
@39: 
	sub	sp,2
	push	bp
	call	near ptr _swap_string_13
	add	sp,8
@40: 
	lea	si,@@2
	push	si
@41: 
	sub	sp,2
	push	bp
	call	near ptr _PutString
	add	sp,6
@42: 
	lea	si,@@3
	push	si
@43: 
	sub	sp,2
	push	bp
	call	near ptr _PutString
	add	sp,6
@44: 
	lea	si,[bp-50]
	push	si
@45: 
	sub	sp,2
	push	bp
	call	near ptr _PutString
	add	sp,6
@46: 
	lea	si,@@4
	push	si
@47: 
	sub	sp,2
	push	bp
	call	near ptr _PutString
	add	sp,6
@48: 
@main_11:
	mov	sp,bp
	pop	bp
	ret
_main_11	endp

@@1	db	'Hello world from Calvin!', 0
@@2	db	'Original String: Hello world from Calvin!', 13, 10, 0
@@3	db	'Reverse String: ', 0
@@4	db	13, 10, 13, 10, 0

	extrn	_StrCopy: proc
	extrn	_StrCat: proc
	extrn	_StrComp: proc
	extrn	_StrLen: proc
	extrn	_PutChar: proc
	extrn	_PutInteger: proc
	extrn	_PutString: proc
	extrn	_GetChar: proc
	extrn	_GetInteger: proc
	extrn	_GetString: proc

xseg	ends
	end	start
