	.text
	.file	"output.ll"
	.globl	main
	.align	16, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# BB#0:                                 # %entry
	pushq	%rax
.Ltmp0:
	.cfi_def_cfa_offset 16
	movl	$.Lconst_string_temp.3, %edi
	callq	writeString
	callq	readInteger
	movl	%eax, 4(%rsp)
	movl	$.Lconst_string_temp.4, %edi
	callq	writeString
	movl	4(%rsp), %ecx
	movl	$.Lconst_string_temp.5, %edi
	movl	$.Lconst_string_temp.6, %esi
	movl	$.Lconst_string_temp.7, %edx
	callq	hanoi
	popq	%rax
	retq
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc

	.globl	hanoi
	.align	16, 0x90
	.type	hanoi,@function
hanoi:                                  # @hanoi
	.cfi_startproc
# BB#0:                                 # %entry
	subq	$40, %rsp
.Ltmp1:
	.cfi_def_cfa_offset 48
	movq	%rdi, 32(%rsp)
	movq	%rsi, 24(%rsp)
	movq	%rdx, 16(%rsp)
	movl	%ecx, 12(%rsp)
	testl	%ecx, %ecx
	je	.LBB1_2
# BB#1:                                 # %temp_true
	movq	32(%rsp), %rdi
	movq	16(%rsp), %rsi
	movq	24(%rsp), %rdx
	movl	12(%rsp), %ecx
	decl	%ecx
	callq	hanoi
	movq	32(%rsp), %rdi
	movq	24(%rsp), %rsi
	callq	move
	movq	16(%rsp), %rdi
	movq	24(%rsp), %rsi
	movq	32(%rsp), %rdx
	movl	12(%rsp), %ecx
	decl	%ecx
	callq	hanoi
.LBB1_2:                                # %end
	addq	$40, %rsp
	retq
.Lfunc_end1:
	.size	hanoi, .Lfunc_end1-hanoi
	.cfi_endproc

	.globl	move
	.align	16, 0x90
	.type	move,@function
move:                                   # @move
	.cfi_startproc
# BB#0:                                 # %entry
	subq	$24, %rsp
.Ltmp2:
	.cfi_def_cfa_offset 32
	movq	%rdi, 16(%rsp)
	movq	%rsi, 8(%rsp)
	movl	$.Lconst_string_temp, %edi
	callq	writeString
	movq	16(%rsp), %rdi
	callq	writeString
	movl	$.Lconst_string_temp.1, %edi
	callq	writeString
	movq	8(%rsp), %rdi
	callq	writeString
	movl	$.Lconst_string_temp.2, %edi
	callq	writeString
	addq	$24, %rsp
	retq
.Lfunc_end2:
	.size	move, .Lfunc_end2-move
	.cfi_endproc

	.type	.Lconst_string_temp,@object # @const_string_temp
	.section	.rodata,"a",@progbits
.Lconst_string_temp:
	.asciz	"Move from "
	.size	.Lconst_string_temp, 11

	.type	.Lconst_string_temp.1,@object # @const_string_temp.1
.Lconst_string_temp.1:
	.asciz	" to "
	.size	.Lconst_string_temp.1, 5

	.type	.Lconst_string_temp.2,@object # @const_string_temp.2
.Lconst_string_temp.2:
	.asciz	".\n"
	.size	.Lconst_string_temp.2, 3

	.type	.Lconst_string_temp.3,@object # @const_string_temp.3
.Lconst_string_temp.3:
	.asciz	"Please, give the number of rings: "
	.size	.Lconst_string_temp.3, 35

	.type	.Lconst_string_temp.4,@object # @const_string_temp.4
.Lconst_string_temp.4:
	.asciz	"\nHere is the solution:\n\n"
	.size	.Lconst_string_temp.4, 25

	.type	.Lconst_string_temp.5,@object # @const_string_temp.5
.Lconst_string_temp.5:
	.asciz	"left"
	.size	.Lconst_string_temp.5, 5

	.type	.Lconst_string_temp.6,@object # @const_string_temp.6
.Lconst_string_temp.6:
	.asciz	"right"
	.size	.Lconst_string_temp.6, 6

	.type	.Lconst_string_temp.7,@object # @const_string_temp.7
.Lconst_string_temp.7:
	.asciz	"middle"
	.size	.Lconst_string_temp.7, 7


	.section	".note.GNU-stack","",@progbits
