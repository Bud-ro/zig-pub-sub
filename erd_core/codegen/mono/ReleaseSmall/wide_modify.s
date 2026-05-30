; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal
; NOINLINE-PUB. In-place modify.
;
wide_modify:
        inc	dword ptr [rdi + 60]
        push	16
        pop	rsi
        mov	rdx, rdi
        jmp	".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).publish"

; --- called functions ---

".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).publish":
        mov	r8, rdx
        movzx	eax, si
        movzx	esi, byte ptr [rax + .L__anon_0]
        movzx	edx, word ptr [rax + rax + .L__anon_1]
        shl	eax, 3
        mov	r9, qword ptr [rax + .L__anon_2]
        mov	rcx, qword ptr [rax + .L__anon_3]
        add	rcx, rdi
        shl	r9, 4
        add	rdi, r9
        add	rdi, 72
        jmp	.Lsystem_data.publishOnChange

