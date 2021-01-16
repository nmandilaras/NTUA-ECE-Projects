xseg	segment	byte public 'code'
	assume	cs:xseg, ds:xseg, ss:xseg
	org	100h

start:
	call	near ptr _main_7

	mov	ax,4c00h
	int	21h

@1: 
_prime_9	proc	near
	push	bp
	mov	bp,sp
	sub	sp,14

@2: 
	mov	ax,[bp+8]
	mov	dx,0
	cmp	ax,dx
	jl	@4
@3: 
	jmp	@10
@4: 
	mov	ax,[bp+8]
	neg	ax
	mov	[bp-4],ax
@5: 
	mov	ax,[bp-4]
	push	ax
@6: 
	lea	si,[bp-6]
	push	si
@7: 
	push	[bp+4]
	call	near ptr _prime_9
	add	sp,6
@8: 
	mov	ax,[bp-6]
	mov	si,[bp+6]
	mov	[si],ax
@9: 
	jmp	@prime_9
@10: 
	mov	ax,[bp+8]
	mov	dx,2
	cmp	ax,dx
	jl	@12
@11: 
	jmp	@14
@12: 
	mov	ax,0
	mov	si,[bp+6]
	mov	[si],ax
@13: 
	jmp	@prime_9
@14: 
	mov	ax,[bp+8]
	mov	dx,2
	cmp	ax,dx
	je	@16
@15: 
	jmp	@18
@16: 
	mov	ax,1
	mov	si,[bp+6]
	mov	[si],ax
@17: 
	jmp	@prime_9
@18: 
	mov	ax,[bp+8]
	xor	dx,dx
	mov	cx,2
	idiv	cx
	mov	[bp-8],dx
@19: 
	mov	ax,[bp-8]
	mov	dx,0
	cmp	ax,dx
	je	@21
@20: 
	jmp	@23
@21: 
	mov	ax,0
	mov	si,[bp+6]
	mov	[si],ax
@22: 
	jmp	@prime_9
@23: 
	mov	ax,3
	mov	[bp-2],ax
@24: 
	mov	ax,[bp+8]
	xor	dx,dx
	mov	cx,2
	idiv	cx
	mov	[bp-10],ax
@25: 
	mov	ax,[bp-2]
	mov	dx,[bp-10]
	cmp	ax,dx
	jle	@27
@26: 
	jmp	@35
@27: 
	mov	ax,[bp+8]
	xor	dx,dx
	mov	cx,[bp-2]
	idiv	cx
	mov	[bp-12],dx
@28: 
	mov	ax,[bp-12]
	mov	dx,0
	cmp	ax,dx
	je	@30
@29: 
	jmp	@32
@30: 
	mov	ax,0
	mov	si,[bp+6]
	mov	[si],ax
@31: 
	jmp	@prime_9
@32: 
	mov	ax,[bp-2]
	mov	dx,2
	add	ax,dx
	mov	[bp-14],ax
@33: 
	mov	ax,[bp-14]
	mov	[bp-2],ax
@34: 
	jmp	@24
@35: 
	mov	ax,1
	mov	si,[bp+6]
	mov	[si],ax
@36: 
	jmp	@prime_9
@37: 
@prime_9:
	mov	sp,bp
	pop	bp
	ret
_prime_9	endp

@38: 
_main_7	proc	near
	push	bp
	mov	bp,sp
	sub	sp,30

@39: 
	lea	si,@@1
	push	si
@40: 
	sub	sp,2
	push	bp
	call	near ptr _PutString
	add	sp,6
@41: 
	lea	si,[bp-8]
	push	si
@42: 
	push	bp
	call	near ptr _GetInteger
	add	sp,4
@43: 
	mov	ax,[bp-8]
	mov	[bp-2],ax
@44: 
	lea	si,@@2
	push	si
@45: 
	sub	sp,2
	push	bp
	call	near ptr _PutString
	add	sp,6
@46: 
	mov	ax,[bp-2]
	push	ax
@47: 
	sub	sp,2
	push	bp
	call	near ptr _PutInteger
	add	sp,6
@48: 
	lea	si,@@3
	push	si
@49: 
	sub	sp,2
	push	bp
	call	near ptr _PutString
	add	sp,6
@50: 
	mov	ax,0
	mov	[bp-6],ax
@51: 
	mov	ax,[bp-2]
	mov	dx,2
	cmp	ax,dx
	jge	@53
@52: 
	jmp	@57
@53: 
	mov	ax,[bp-6]
	mov	dx,1
	add	ax,dx
	mov	[bp-10],ax
@54: 
	mov	ax,[bp-10]
	mov	[bp-6],ax
@55: 
	lea	si,@@4
	push	si
@56: 
	sub	sp,2
	push	bp
	call	near ptr _PutString
	add	sp,6
@57: 
	mov	ax,[bp-2]
	mov	dx,3
	cmp	ax,dx
	jge	@59
@58: 
	jmp	@63
@59: 
	mov	ax,[bp-6]
	mov	dx,1
	add	ax,dx
	mov	[bp-12],ax
@60: 
	mov	ax,[bp-12]
	mov	[bp-6],ax
@61: 
	lea	si,@@5
	push	si
@62: 
	sub	sp,2
	push	bp
	call	near ptr _PutString
	add	sp,6
@63: 
	mov	ax,6
	mov	[bp-4],ax
@64: 
	mov	ax,[bp-4]
	mov	dx,[bp-2]
	cmp	ax,dx
	jle	@66
@65: 
	jmp	@97
@66: 
	mov	ax,[bp-4]
	mov	dx,1
	sub	ax,dx
	mov	[bp-14],ax
@67: 
	mov	ax,[bp-14]
	push	ax
@68: 
	lea	si,[bp-16]
	push	si
@69: 
	push	bp
	call	near ptr _prime_9
	add	sp,6
@70: 
	mov	ax,[bp-16]
	mov	dx,0
	cmp	ax,dx
	jg	@72
@71: 
	jmp	@79
@72: 
	mov	ax,[bp-6]
	mov	dx,1
	add	ax,dx
	mov	[bp-18],ax
@73: 
	mov	ax,[bp-18]
	mov	[bp-6],ax
@74: 
	mov	ax,[bp-4]
	mov	dx,1
	sub	ax,dx
	mov	[bp-20],ax
@75: 
	mov	ax,[bp-20]
	push	ax
@76: 
	sub	sp,2
	push	bp
	call	near ptr _PutInteger
	add	sp,6
@77: 
	lea	si,@@6
	push	si
@78: 
	sub	sp,2
	push	bp
	call	near ptr _PutString
	add	sp,6
@79: 
	mov	ax,[bp-4]
	mov	dx,[bp-2]
	cmp	ax,dx
	jne	@81
@80: 
	jmp	@94
@81: 
	mov	ax,[bp-4]
	mov	dx,1
	add	ax,dx
	mov	[bp-22],ax
@82: 
	mov	ax,[bp-22]
	push	ax
@83: 
	lea	si,[bp-24]
	push	si
@84: 
	push	bp
	call	near ptr _prime_9
	add	sp,6
@85: 
	mov	ax,[bp-24]
	mov	dx,0
	cmp	ax,dx
	jg	@87
@86: 
	jmp	@94
@87: 
	mov	ax,[bp-6]
	mov	dx,1
	add	ax,dx
	mov	[bp-26],ax
@88: 
	mov	ax,[bp-26]
	mov	[bp-6],ax
@89: 
	mov	ax,[bp-4]
	mov	dx,1
	add	ax,dx
	mov	[bp-28],ax
@90: 
	mov	ax,[bp-28]
	push	ax
@91: 
	sub	sp,2
	push	bp
	call	near ptr _PutInteger
	add	sp,6
@92: 
	lea	si,@@7
	push	si
@93: 
	sub	sp,2
	push	bp
	call	near ptr _PutString
	add	sp,6
@94: 
	mov	ax,[bp-4]
	mov	dx,6
	add	ax,dx
	mov	[bp-30],ax
@95: 
	mov	ax,[bp-30]
	mov	[bp-4],ax
@96: 
	jmp	@64
@97: 
	lea	si,@@8
	push	si
@98: 
	sub	sp,2
	push	bp
	call	near ptr _PutString
	add	sp,6
@99: 
	mov	ax,[bp-6]
	push	ax
@100: 
	sub	sp,2
	push	bp
	call	near ptr _PutInteger
	add	sp,6
@101: 
	lea	si,@@9
	push	si
@102: 
	sub	sp,2
	push	bp
	call	near ptr _PutString
	add	sp,6
@103: 
@main_7:
	mov	sp,bp
	pop	bp
	ret
_main_7	endp

@@1	db	'Please give the upper limit: ', 0
@@2	db	'Prime numbers between 0 and ', 0
@@3	db	':', 13, 10, 13, 10, 0
@@4	db	'2', 13, 10, 0
@@5	db	'3', 13, 10, 0
@@6	db	13, 10, 0
@@7	db	13, 10, 0
@@8	db	13, 10, 0
@@9	db	' prime number(s) were found.', 13, 10, 13, 10, 0

	extrn	_PutChar: proc
	extrn	_PutInteger: proc
	extrn	_PutString: proc
	extrn	_GetChar: proc
	extrn	_GetInteger: proc
	extrn	_GetString: proc

xseg	ends
	end	start
