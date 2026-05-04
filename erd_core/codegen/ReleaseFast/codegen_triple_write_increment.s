codegen_triple_write_increment:
        push	rbp
        mov	rbp, rsp
        push	rbx
        push	rax
        mov	rbx, rdi
        mov	word ptr [rbp - 14], 1
        cmp	word ptr [rdi + 7], 1
        mov	word ptr [rdi + 7], 1
        jne	.LBB144_3
        mov	word ptr [rbp - 10], 2
        mov	word ptr [rbx + 7], 2
        jmp	.LBB144_2
.LBB144_3:
        lea	rdx, [rbp - 14]
        mov	rdi, rbx
        mov	esi, 3
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"
        movzx	eax, word ptr [rbx + 7]
        mov	word ptr [rbp - 10], 2
        mov	word ptr [rbx + 7], 2
        cmp	ax, 2
        jne	.LBB144_2
        mov	word ptr [rbp - 12], 3
        mov	word ptr [rbx + 7], 3
        jmp	.LBB144_5
.LBB144_2:
        lea	rdx, [rbp - 10]
        mov	rdi, rbx
        mov	esi, 3
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"
        movzx	eax, word ptr [rbx + 7]
        mov	word ptr [rbp - 12], 3
        mov	word ptr [rbx + 7], 3
        cmp	ax, 3
        je	.LBB144_6
.LBB144_5:
        lea	rdx, [rbp - 12]
        mov	rdi, rbx
        mov	esi, 3
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"
.LBB144_6:
        add	rsp, 8
        pop	rbx
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

