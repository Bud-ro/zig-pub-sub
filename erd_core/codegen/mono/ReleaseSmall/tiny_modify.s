; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal
; NOINLINE-PUB. In-place modify.
;
tiny_modify:
        lea	rdx, [rdi + 5]
        inc	dword ptr [rdi + 5]
        push	2
        pop	rsi
        mov	rcx, rdi
        jmp	".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish"

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
        jmp	.Lsystem_data.publishOnChange

