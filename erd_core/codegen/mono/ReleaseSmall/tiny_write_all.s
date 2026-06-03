; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal (until 2 calls)
; NOINLINE-PUB. PER-ERD: 2 writes inlined.
;
tiny_write_all:
        push	rbp
        push	rbx
        push	rax
        mov	ebp, edx
        mov	rbx, rdi
        cmp	dword ptr [rdi], esi
        mov	dword ptr [rdi], esi
        je	.L0
        mov	rdi, rbx
        xor	esi, esi
        mov	rdx, rbx
        call	".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish"
.L0:
        and	bpl, 1
        cmp	byte ptr [rbx + 4], bpl
        mov	byte ptr [rbx + 4], bpl
        je	.L1
        push	1
        pop	rsi
        mov	rdi, rbx
        mov	rdx, rbx
        add	rsp, 8
        pop	rbx
        pop	rbp
        jmp	".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish"
.L1:
        add	rsp, 8
        pop	rbx
        pop	rbp
        ret

; --- called functions ---

".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish":
        mov	r8, rdx
        movzx	eax, si
        lea	ecx, [8*rax]
        mov	rdx, qword ptr [rcx + .L__anon_0]
        mov	rcx, qword ptr [rcx + .L__anon_1]
        add	rcx, rdi
        shl	rdx, 4
        add	rdi, rdx
        add	rdi, 16
        movzx	edx, word ptr [rax + rax + .L__anon_2]
        mov	esi, 1
        jmp	.Lsystem_data.publishOnChange

