	.text
	.intel_syntax noprefix
	.file	"out.ll"
	.section	.rodata.cst4,"aM",@progbits,4
	.align	4
.LCPI0_0:
	.long	1077936128              # float 3
	.text
	.globl	main
	.align	16, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# BB#0:
	push	rbp
.Ltmp0:
	.cfi_def_cfa_offset 16
.Ltmp1:
	.cfi_offset rbp, -16
	mov	rbp, rsp
.Ltmp2:
	.cfi_def_cfa_register rbp
	sub	rsp, 48
	mov	dword ptr [rbp - 4], 0
	fld	dword ptr [rip + .LCPI0_0]
	fld	st(0)
	fstp	xword ptr [rbp - 32]
	fstp	xword ptr [rsp]
	call	writeReal
	xor	eax, eax
	add	rsp, 48
	pop	rbp
	ret
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc


	.ident	"clang version 3.8.0-2ubuntu3~trusty4 (tags/RELEASE_380/final)"
	.section	".note.GNU-stack","",@progbits
