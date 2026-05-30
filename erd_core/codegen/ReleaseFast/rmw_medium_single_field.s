; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal (until 2 calls)
; NOINLINE-PUB. Read-modify-write: field-aware detection proves the field changed -> in-place update + guaranteed publish.
;
rmw_medium_single_field:
        add	dword ptr [rdi + 272], 1
        mov	rsi, rdi
        jmp	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"

; --- called functions ---

"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish":
        mov	r8, rsi
        lea	rcx, [rdi + 256]
        add	rdi, 312
        mov	esi, 1
        mov	edx, 1
        jmp	system_data.publishOnChange

