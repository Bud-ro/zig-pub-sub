; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal
;
unpub_write_with_subs:
        push	rax
        mov	dword ptr [rsp + 4], esi
        cmp	dword ptr [rdi + 54], esi
        mov	dword ptr [rdi + 54], esi
        je	.L0
        push	4
        pop	rsi
        lea	rdx, [rsp + 4]
        mov	rcx, rdi
        call	".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..6]).publish"
.L0:
        pop	rax
        ret

; --- called functions ---

".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..6]).publish":
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

