; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal (until 2 calls)
; NOINLINE-PUB. Two in-place modifies, each publishes.
;
double_modify_struct:
        push	rbx
        mov	rbx, rdi
        inc	dword ptr [rdi + 272]
        mov	rsi, rdi
        call	".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"
        inc	qword ptr [rbx + 256]
        mov	rdi, rbx
        mov	rsi, rbx
        pop	rbx
        jmp	".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"

; --- called functions ---

".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish":
        mov	r8, rsi
        lea	rcx, [rdi + 256]
        add	rdi, 312
        mov	esi, 1
        mov	edx, 1
        jmp	.Lsystem_data.publishOnChange

