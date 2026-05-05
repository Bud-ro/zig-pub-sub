write_u16_with_subs:
        push	rax
        mov	word ptr [rsp + 6], si
        cmp	word ptr [rdi + 7], si
        mov	word ptr [rdi + 7], si
        je	.LBB324_2
        lea	rdx, [rsp + 6]
        mov	esi, 3
        mov	rcx, rdi
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish.2"
.LBB324_2:
        pop	rax
        ret

; --- called functions ---

"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish.2":
        push	rbp
        push	r15
        push	r14
        push	r13
        push	r12
        push	rbx
        sub	rsp, 24
        movzx	r12d, si
        movzx	r13d, byte ptr [r12 + __anon_0]
        test	r13, r13
        je	.LBB8_4
        mov	rbx, rcx
        mov	r14, rdx
        mov	rax, qword ptr [8*r12 + __anon_1]
        shl	r13d, 4
        shl	rax, 4
        lea	rbp, [rdi + rax]
        add	rbp, 24
        xor	r15d, r15d
        jmp	.LBB8_2
.LBB8_3:
        add	r15, 16
        cmp	r13, r15
        je	.LBB8_4
.LBB8_2:
        mov	rax, qword ptr [rbp + r15]
        test	rax, rax
        je	.LBB8_3
        mov	rdi, qword ptr [rbp + r15 - 8]
        movzx	ecx, word ptr [r12 + r12 + __anon_2]
        mov	word ptr [rsp + 16], cx
        mov	qword ptr [rsp + 8], r14
        lea	rsi, [rsp + 8]
        mov	rdx, rbx
        call	rax
        jmp	.LBB8_3
.LBB8_4:
        add	rsp, 24
        pop	rbx
        pop	r12
        pop	r13
        pop	r14
        pop	r15
        pop	rbp
        ret

