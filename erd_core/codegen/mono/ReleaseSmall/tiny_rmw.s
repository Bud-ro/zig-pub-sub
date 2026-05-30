; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal
; NOINLINE-PUB. Read-modify-write of a struct field (proven change).
;
tiny_rmw:
        mov	rax, qword ptr [rdi + 8]
        movabs	rcx, -4294967296
        and	rcx, rax
        lea	edx, [rax + 1]
        or	rdx, rcx
        mov	qword ptr [rdi + 8], rdx
        cmp	rdx, rax
        je	.L0
        push	2
        pop	rsi
        mov	rdx, rdi
        jmp	".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish"
.L0:
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

