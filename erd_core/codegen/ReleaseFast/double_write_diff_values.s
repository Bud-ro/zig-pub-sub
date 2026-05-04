double_write_diff_values:
        push	rbp
        mov	rbp, rsp
        push	rbx
        push	rax
        mov	rbx, rdi
        mov	byte ptr [rbp - 9], 1
        mov	al, 1
        cmp	byte ptr [rdi + 4], 1
        mov	byte ptr [rdi + 4], 1
        jne	.LBB7_1
        mov	byte ptr [rbp - 10], 0
        mov	byte ptr [rbx + 4], 0
        cmp	al, 0
        jne	.LBB7_3
.LBB7_4:
        add	rsp, 8
        pop	rbx
        pop	rbp
        ret
.LBB7_1:
        lea	rdx, [rbp - 9]
        mov	rdi, rbx
        mov	esi, 1
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"
        movzx	eax, byte ptr [rbx + 4]
        mov	byte ptr [rbp - 10], 0
        mov	byte ptr [rbx + 4], 0
        cmp	al, 0
        je	.LBB7_4
.LBB7_3:
        lea	rdx, [rbp - 10]
        mov	rdi, rbx
        mov	esi, 1
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"
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
        movzx	r12d, si
        movzx	r13d, byte ptr [r12 + __anon_1928]
        test	r13, r13
        je	.LBB5_4
        mov	r14, rdx
        mov	rax, qword ptr [8*r12 + __anon_1922]
        shl	r13d, 4
        shl	rax, 4
        lea	r15, [rdi + rax]
        add	r15, 24
        xor	ebx, ebx
        jmp	.LBB5_2
.LBB5_3:
        add	rbx, 16
        cmp	r13, rbx
        je	.LBB5_4
.LBB5_2:
        mov	rax, qword ptr [r15 + rbx]
        test	rax, rax
        je	.LBB5_3
        mov	rdi, qword ptr [r15 + rbx - 8]
        movzx	ecx, word ptr [r12 + r12 + __anon_1938]
        mov	word ptr [rbp - 56], cx
        mov	qword ptr [rbp - 64], r14
        lea	rsi, [rbp - 64]
        mov	rdx, qword ptr [rbp - 48]
        call	rax
        jmp	.LBB5_3
.LBB5_4:
        add	rsp, 24
        pop	rbx
        pop	r12
        pop	r13
        pop	r14
        pop	r15
        pop	rbp
        ret

