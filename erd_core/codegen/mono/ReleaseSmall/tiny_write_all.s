tiny_write_all:
        push	rbp
        push	rbx
        sub	rsp, 24
        mov	ebp, edx
        mov	rbx, rdi
        mov	dword ptr [rsp + 16], esi
        cmp	dword ptr [rdi], esi
        mov	dword ptr [rdi], esi
        je	.LBB305_2
        lea	rdx, [rsp + 16]
        mov	rdi, rbx
        xor	esi, esi
        mov	rcx, rbx
        call	".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish"
.LBB305_2:
        and	bpl, 1
        mov	byte ptr [rsp + 15], bpl
        cmp	byte ptr [rbx + 4], bpl
        mov	byte ptr [rbx + 4], bpl
        je	.LBB305_4
        push	1
        pop	rsi
        lea	rdx, [rsp + 15]
        mov	rdi, rbx
        mov	rcx, rbx
        call	".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish"
.LBB305_4:
        add	rsp, 24
        pop	rbx
        pop	rbp
        ret

; --- called functions ---

".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish":
        mov	r8, rcx
        mov	rcx, rdx
        movzx	eax, si
        mov	rdx, qword ptr [8*rax + .L__anon_0]
        shl	rdx, 4
        add	rdi, rdx
        add	rdi, 16
        movzx	edx, word ptr [rax + rax + .L__anon_1]
        mov	esi, 1
        jmp	.LSubscription.publish

