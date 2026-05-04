write_u16_with_subs:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        mov	word ptr [rbp - 2], si
        cmp	word ptr [rdi + 7], si
        mov	word ptr [rdi + 7], si
        je	.LBB7_2
        lea	rdx, [rbp - 2]
        mov	esi, 3
        mov	rcx, rdi
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"
.LBB7_2:
        add	rsp, 16
        pop	rbp
        ret

; --- called functions ---

"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish":
        push	rbp
        mov	rbp, rsp
        push	r15
        push	r14
        push	r13
        push	r12
        push	rbx
        sub	rsp, 24
        mov	qword ptr [rbp - 48], rcx
        test	esi, 65533
        je	.LBB6_4
        mov	r14, rdx
        movzx	r12d, si
        mov	rax, qword ptr [8*r12 + .L__unnamed_1]
        movzx	ecx, byte ptr [r12 + .L__unnamed_2]
        cmp	cl, 1
        adc	ecx, 0
        movzx	r13d, cl
        shl	r13d, 4
        shl	rax, 4
        lea	r15, [rdi + rax]
        add	r15, 24
        xor	ebx, ebx
        jmp	.LBB6_2
.LBB6_3:
        add	rbx, 16
        cmp	r13, rbx
        je	.LBB6_4
.LBB6_2:
        mov	rax, qword ptr [r15 + rbx]
        test	rax, rax
        je	.LBB6_3
        mov	rdi, qword ptr [r15 + rbx - 8]
        movzx	ecx, word ptr [r12 + r12 + .L__unnamed_3]
        mov	word ptr [rbp - 56], cx
        mov	qword ptr [rbp - 64], r14
        lea	rsi, [rbp - 64]
        mov	rdx, qword ptr [rbp - 48]
        call	rax
        jmp	.LBB6_3
.LBB6_4:
        add	rsp, 24
        pop	rbx
        pop	r12
        pop	r13
        pop	r14
        pop	r15
        pop	rbp
        ret

