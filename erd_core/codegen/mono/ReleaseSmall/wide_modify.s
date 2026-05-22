; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal
; NOINLINE-PUB. In-place modify.
;
wide_modify:
        lea	rdx, [rdi + 55]
        inc	dword ptr [rdi + 55]
        push	16
        pop	rsi
        mov	rcx, rdi
        jmp	".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).publish"

; --- called functions ---

".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).publish":
        mov	r8, rcx
        mov	rcx, rdx
        movzx	eax, si
        mov	rdx, qword ptr [8*rax + .L__anon_0]
        movzx	esi, byte ptr [rax + .L__anon_1]
        shl	rdx, 4
        add	rdi, rdx
        add	rdi, 64
        movzx	edx, word ptr [rax + rax + .L__anon_2]
        jmp	.LSubscription.publish

