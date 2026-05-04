write_bool_with_subs:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        and	sil, 1
        mov	byte ptr [rbp - 1], sil
        cmp	byte ptr [rdi + 4], sil
        mov	byte ptr [rdi + 4], sil
        je	.LBB319_2
        lea	rdx, [rbp - 1]
        mov	esi, 1
        mov	rcx, rdi
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"
.LBB319_2:
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

