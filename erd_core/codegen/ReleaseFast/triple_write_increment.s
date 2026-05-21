; snapshot_comments.zig
; Speed: Optimal | Size: Optimal (until 2 calls)
;
triple_write_increment:
        push	rbx
        sub	rsp, 16
        mov	rbx, rdi
        mov	word ptr [rsp + 14], 1
        cmp	word ptr [rdi + 7], 1
        mov	word ptr [rdi + 7], 1
        jne	.L0
        mov	word ptr [rsp + 10], 2
        mov	word ptr [rbx + 7], 2
        jmp	.L1
.L0:
        lea	rdx, [rsp + 14]
        mov	rdi, rbx
        mov	esi, 3
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish.2"
        movzx	eax, word ptr [rbx + 7]
        mov	word ptr [rsp + 10], 2
        mov	word ptr [rbx + 7], 2
        cmp	ax, 2
        jne	.L1
        mov	word ptr [rsp + 12], 3
        mov	word ptr [rbx + 7], 3
        jmp	.L2
.L1:
        lea	rdx, [rsp + 10]
        mov	rdi, rbx
        mov	esi, 3
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish.2"
        movzx	eax, word ptr [rbx + 7]
        mov	word ptr [rsp + 12], 3
        mov	word ptr [rbx + 7], 3
        cmp	ax, 3
        je	.L3
.L2:
        lea	rdx, [rsp + 12]
        mov	rdi, rbx
        mov	esi, 3
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish.2"
.L3:
        add	rsp, 16
        pop	rbx
        ret

; --- called functions ---

"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish.2":
        mov	r8, rcx
        mov	rcx, rdx
        movzx	eax, si
        mov	rdx, qword ptr [8*rax + __anon_4]
        movzx	esi, byte ptr [rax + __anon_5]
        shl	rdx, 4
        add	rdi, rdx
        add	rdi, 16
        movzx	edx, word ptr [rax + rax + __anon_6]
        jmp	Subscription.publish

