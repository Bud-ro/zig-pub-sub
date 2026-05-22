; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal (until 2 calls)
; NOINLINE-PUB. Two in-place modifies, each publishes.
;
double_modify_struct:
        push	r14
        push	rbx
        push	rax
        mov	rbx, rdi
        lea	r14, [rdi + 256]
        add	dword ptr [rdi + 272], 1
        mov	rsi, r14
        mov	rdx, rdi
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"
        add	qword ptr [rbx + 256], 1
        mov	rdi, rbx
        mov	rsi, r14
        mov	rdx, rbx
        add	rsp, 8
        pop	rbx
        pop	r14
        jmp	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"

; --- called functions ---

"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish":
        mov	r8, rdx
        mov	rcx, rsi
        add	rdi, 312
        mov	esi, 1
        mov	edx, 1
        jmp	Subscription.publish

