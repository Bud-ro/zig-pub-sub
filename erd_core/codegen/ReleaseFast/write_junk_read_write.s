write_junk_read_write:
        push	rbx
        sub	rsp, 16
        mov	rbx, rdi
        mov	word ptr [rsp + 14], 1
        cmp	word ptr [rdi + 7], 1
        mov	word ptr [rdi + 7], 1
        jne	.LBB309_2
        mov	word ptr [rsp + 12], 2
        mov	word ptr [rbx + 7], 2
        jmp	.LBB309_3
.LBB309_2:
        lea	rdx, [rsp + 14]
        mov	rdi, rbx
        mov	esi, 3
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish.2"
        movzx	eax, word ptr [rbx + 7]
        mov	word ptr [rsp + 12], 2
        mov	word ptr [rbx + 7], 2
        cmp	ax, 2
        je	.LBB309_4
.LBB309_3:
        lea	rdx, [rsp + 12]
        mov	rdi, rbx
        mov	esi, 3
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish.2"
.LBB309_4:
        add	rsp, 16
        pop	rbx
        ret

; --- called functions ---

"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish.2":
        mov	r8, rcx
        mov	rcx, rdx
        movzx	eax, si
        mov	rdx, qword ptr [8*rax + __anon_0]
        movzx	esi, byte ptr [rax + __anon_1]
        shl	rdx, 4
        add	rdi, rdx
        add	rdi, 16
        movzx	edx, word ptr [rax + rax + __anon_2]
        jmp	Subscription.publish

