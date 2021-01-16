xseg	segment	byte public 'code'
	assume	cs:xseg, ds:xseg, ss:xseg
	org	100h

start:
	call	near ptr _main_7

	mov	ax,4c00h
	int	21h

@1: 
_main_7	proc	near
	push	bp
	mov	bp,sp
	sub	sp,2012

@2: 
	mov	ax,0
	mov	[bp-2004],ax
@3: 
	mov	ax,[bp-2004]
	mov	dx,1000
	cmp	ax,dx
	jle	@5
@4: 
	jmp	@9
@5: 
	mov	ax,0
	mov	di,[bp-2004]
	shl	di,1
	lea	si,[bp-2002]
	add	si,di
	mov	[si],ax
@6: 
	mov	ax,[bp-2004]
	mov	dx,1
	add	ax,dx
	mov	[bp-2008],ax
@7: 
	mov	ax,[bp-2008]
	mov	[bp-2004],ax
@8: 
	jmp	@3
@9: 
	mov	ax,1
	push	ax
@10: 
	sub	sp,2
	push	bp
	call	near ptr _PutInteger
	add	sp,6
@11: 
	lea	si,@@1
	push	si
@12: 
	sub	sp,2
	push	bp
	call	near ptr _PutString
	add	sp,6
@13: 
	mov	ax,2
	mov	[bp-2006],ax
@14: 
	mov	ax,[bp-2006]
	mov	dx,1000
	cmp	ax,dx
	jle	@16
@15: 
	jmp	@32
@16: 
	mov	di,[bp-2006]
	shl	di,1
	lea	si,[bp-2002]
	add	si,di
	mov	ax,[si]
	mov	dx,0
	cmp	ax,dx
	je	@18
@17: 
	jmp	@29
@18: 
	mov	ax,[bp-2006]
	push	ax
@19: 
	sub	sp,2
	push	bp
	call	near ptr _PutInteger
	add	sp,6
@20: 
	lea	si,@@2
	push	si
@21: 
	sub	sp,2
	push	bp
	call	near ptr _PutString
	add	sp,6
@22: 
	mov	ax,[bp-2006]
	mov	[bp-2004],ax
@23: 
	mov	ax,[bp-2004]
	mov	dx,1000
	cmp	ax,dx
	jle	@25
@24: 
	jmp	@29
@25: 
	mov	ax,1
	mov	di,[bp-2004]
	shl	di,1
	lea	si,[bp-2002]
	add	si,di
	mov	[si],ax
@26: 
	mov	ax,[bp-2004]
	mov	dx,[bp-2006]
	add	ax,dx
	mov	[bp-2010],ax
@27: 
	mov	ax,[bp-2010]
	mov	[bp-2004],ax
@28: 
	jmp	@23
@29: 
	mov	ax,[bp-2006]
	mov	dx,1
	add	ax,dx
	mov	[bp-2012],ax
@30: 
	mov	ax,[bp-2012]
	mov	[bp-2006],ax
@31: 
	jmp	@14
@32: 
	jmp	@main_7
@33: 
@main_7:
	mov	sp,bp
	pop	bp
	ret
_main_7	endp

@@1	db	9, 0
@@2	db	9, 0

	extrn	_PutChar: proc
	extrn	_PutInteger: proc
	extrn	_PutString: proc
	extrn	_GetChar: proc
	extrn	_GetInteger: proc
	extrn	_GetString: proc

xseg	ends
	end	start
