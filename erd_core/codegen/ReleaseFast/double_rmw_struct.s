; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal (until 2 calls)
; NOINLINE-PUB. Two read-modify-writes. ReleaseFast proves each change (branchless publishes); ReleaseSmall calls out-of-line write, retaining the runtime compares.
;
double_rmw_struct:
        push	rbx
        mov	rbx, rdi
        add	dword ptr [rdi + 272], 1
        mov	rsi, rdi
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"
        add	qword ptr [rbx + 256], 1
        mov	rdi, rbx
        mov	rsi, rbx
        pop	rbx
        jmp	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"

; --- called functions ---

"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish":
        mov	r8, rsi
        lea	rcx, [rdi + 256]
        add	rdi, 312
        mov	esi, 1
        mov	edx, 1
        jmp	system_data.publishOnChange

