; snapshot_comments.zig
; Speed: Optimal | Size: Optimal
;
tiny_modify:
        lea	rdx, [rdi + 5]
        add	dword ptr [rdi + 5], 1
        mov	esi, 2
        mov	rcx, rdi
        jmp	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish"

; --- called functions ---

"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish":
        mov	r8, rcx
        mov	rcx, rdx
        movzx	eax, si
        mov	rdx, qword ptr [8*rax + __anon_0]
        shl	rdx, 4
        add	rdi, rdx
        add	rdi, 16
        movzx	edx, word ptr [rax + rax + __anon_1]
        mov	esi, 1
        jmp	Subscription.publish

