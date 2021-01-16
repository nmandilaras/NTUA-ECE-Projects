xseg	segment	byte public 'code'
	assume	cs:xseg, ds:xseg, ss:xseg
	org	100h

start:
	call	near ptr _main_7

	mov	ax,4c00h
	int	21h

@1: 
_swap_11	proc	near
	push	bp
	mov	bp,sp
	sub	sp,2

@2: 
	mov	si,[bp+10]
	mov	ax,[si]
	mov	[bp-2],ax
@3: 
	mov	si,[bp+8]
	mov	ax,[si]
	mov	si,[bp+10]
	mov	[si],ax
@4: 
	mov	ax,[bp-2]
	mov	si,[bp+8]
	mov	[si],ax
@5: 
@swap_11:
	mov	sp,bp
	pop	bp
	ret
_swap_11	endp

@6: 
_BubbleSort_9	proc	near
	push	bp
	mov	bp,sp
	sub	sp,12

@7: 
	mov	ax,1
	mov	[bp-4],ax
@8: 
	mov	ax,[bp-4]
	mov	dx,1
	cmp	ax,dx
	je	@10
@9: 
	jmp	@27
@10: 
	mov	ax,0
	mov	[bp-2],ax
@11: 
	mov	ax,0
	mov	[bp-4],ax
@12: 
	mov	ax,[bp+8]
	mov	dx,1
	sub	ax,dx
	mov	[bp-6],ax
@13: 
	mov	ax,[bp-2]
	mov	dx,[bp-6]
	cmp	ax,dx
	jl	@15
@14: 
	jmp	@26
@15: 
	mov	ax,[bp-2]
	mov	dx,1
	add	ax,dx
	mov	[bp-8],ax
@16: 
	mov	di,[bp-2]
	shl	di,1
	mov	si,[bp+10]
	add	si,di
	mov	ax,[si]
	mov	di,[bp-8]
	shl	di,1
	mov	si,[bp+10]
	add	si,di
	mov	dx,[si]
	cmp	ax,dx
	jl	@18
@17: 
	jmp	@23
@18: 
	mov	di,[bp-2]
	shl	di,1
	mov	si,[bp+10]
	add	si,di
	push	si
@19: 
	mov	ax,[bp-2]
	mov	dx,1
	add	ax,dx
	mov	[bp-10],ax
@20: 
	mov	di,[bp-10]
	shl	di,1
	mov	si,[bp+10]
	add	si,di
	push	si
@21: 
	sub	sp,2
	push	bp
	call	near ptr _swap_11
	add	sp,8
@22: 
	mov	ax,1
	mov	[bp-4],ax
@23: 
	mov	ax,[bp-2]
	mov	dx,1
	add	ax,dx
	mov	[bp-12],ax
@24: 
	mov	ax,[bp-12]
	mov	[bp-2],ax
@25: 
	jmp	@12
@26: 
	jmp	@8
@27: 
@BubbleSort_9:
	mov	sp,bp
	pop	bp
	ret
_BubbleSort_9	endp

@28: 
_PrintArray_13	proc	near
	push	bp
	mov	bp,sp
	sub	sp,4

@29: 
	mov	si,[bp+12]
	push	si
@30: 
	sub	sp,2
	push	bp
	call	near ptr _PutString
	add	sp,6
@31: 
	mov	ax,0
	mov	[bp-2],ax
@32: 
	mov	ax,[bp-2]
	mov	dx,[bp+8]
	cmp	ax,dx
	jl	@34
@33: 
	jmp	@43
@34: 
	mov	ax,[bp-2]
	mov	dx,0
	cmp	ax,dx
	jg	@36
@35: 
	jmp	@38
@36: 
	lea	si,@@1
	push	si
@37: 
	sub	sp,2
	push	bp
	call	near ptr _PutString
	add	sp,6
@38: 
	mov	di,[bp-2]
	shl	di,1
	mov	si,[bp+10]
	add	si,di
	mov	ax,[si]
	push	ax
@39: 
	sub	sp,2
	push	bp
	call	near ptr _PutInteger
	add	sp,6
@40: 
	mov	ax,[bp-2]
	mov	dx,1
	add	ax,dx
	mov	[bp-4],ax
@41: 
	mov	ax,[bp-4]
	mov	[bp-2],ax
@42: 
	jmp	@32
@43: 
	lea	si,@@2
	push	si
@44: 
	sub	sp,2
	push	bp
	call	near ptr _PutString
	add	sp,6
@45: 
@PrintArray_13:
	mov	sp,bp
	pop	bp
	ret
_PrintArray_13	endp

@46: 
_main_7	proc	near
	push	bp
	mov	bp,sp
	sub	sp,46

@47: 
	mov	ax,0
	mov	[bp-2],ax
@48: 
	mov	ax,70
	mov	[bp-36],ax
@49: 
	mov	ax,[bp-2]
	mov	dx,16
	cmp	ax,dx
	jl	@51
@50: 
	jmp	@60
@51: 
	mov	ax,[bp-36]
	mov	cx,137
	imul	cx
	mov	[bp-38],ax
@52: 
	mov	ax,[bp-38]
	mov	dx,221
	add	ax,dx
	mov	[bp-40],ax
@53: 
	mov	ax,[bp-40]
	mov	dx,[bp-2]
	add	ax,dx
	mov	[bp-42],ax
@54: 
	mov	ax,[bp-42]
	xor	dx,dx
	mov	cx,101
	idiv	cx
	mov	[bp-44],dx
@55: 
	mov	ax,[bp-44]
	mov	[bp-36],ax
@56: 
	mov	ax,[bp-36]
	mov	di,[bp-2]
	shl	di,1
	lea	si,[bp-34]
	add	si,di
	mov	[si],ax
@57: 
	mov	ax,[bp-2]
	mov	dx,1
	add	ax,dx
	mov	[bp-46],ax
@58: 
	mov	ax,[bp-46]
	mov	[bp-2],ax
@59: 
	jmp	@49
@60: 
	lea	si,@@3
	push	si
@61: 
	lea	si,[bp-34]
	push	si
@62: 
	mov	ax,16
	push	ax
@63: 
	sub	sp,2
	push	bp
	call	near ptr _PrintArray_13
	add	sp,10
@64: 
	lea	si,[bp-34]
	push	si
@65: 
	mov	ax,16
	push	ax
@66: 
	sub	sp,2
	push	bp
	call	near ptr _BubbleSort_9
	add	sp,8
@67: 
	lea	si,@@4
	push	si
@68: 
	lea	si,[bp-34]
	push	si
@69: 
	mov	ax,16
	push	ax
@70: 
	sub	sp,2
	push	bp
	call	near ptr _PrintArray_13
	add	sp,10
@71: 
@main_7:
	mov	sp,bp
	pop	bp
	ret
_main_7	endp

@@1	db	', ', 0
@@2	db	13, 10, 0
@@3	db	'Initial Array: ', 0
@@4	db	'Sorted Array: ', 0

	extrn	_PutChar: proc
	extrn	_PutInteger: proc
	extrn	_PutString: proc
	extrn	_GetChar: proc
	extrn	_GetInteger: proc
	extrn	_GetString: proc

xseg	ends
	end	start
