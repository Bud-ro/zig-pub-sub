; snapshot_comments.zig
; Speed: Optimal | Size: Optimal (until 2 calls)
;
modify_medium_two_fields:
        add	qword ptr [rdi + 256], 1
        add	dword ptr [rdi + 272], 1
        lea	rsi, [rdi + 256]
        mov	rdx, rdi
        jmp	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"

; --- called functions ---

"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish":
        mov	r8, rdx
        mov	rcx, rsi
        add	rdi, 312
        mov	esi, 1
        mov	edx, 1
        jmp	Subscription.publish

