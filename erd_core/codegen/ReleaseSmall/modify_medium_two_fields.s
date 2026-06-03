; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal (until 2 calls)
; NOINLINE-PUB. In-place modify + unconditional publish.
;
modify_medium_two_fields:
        inc	qword ptr [rdi + 256]
        inc	dword ptr [rdi + 272]
        mov	rsi, rdi
        jmp	".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"

; --- called functions ---

".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish":
        mov	r8, rsi
        lea	rcx, [rdi + 256]
        add	rdi, 312
        mov	esi, 1
        mov	edx, 1
        jmp	.Lsystem_data.publishOnChange

