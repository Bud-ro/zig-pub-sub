double_write_diff_values:
        push	rbx
        sub	rsp, 16
        mov	rbx, rdi
        mov	byte ptr [rsp + 12], 1
        mov	al, 1
        cmp	byte ptr [rdi + 4], 1
        mov	byte ptr [rdi + 4], 1
        jne	.LBB310_1
        mov	byte ptr [rsp + 13], 0
        mov	byte ptr [rbx + 4], 0
        cmp	al, 0
        jne	.LBB310_3
.LBB310_4:
        add	rsp, 16
        pop	rbx
        ret
.LBB310_1:
        lea	rdx, [rsp + 12]
        mov	rdi, rbx
        mov	esi, 1
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish.2"
        movzx	eax, byte ptr [rbx + 4]
        mov	byte ptr [rsp + 13], 0
        mov	byte ptr [rbx + 4], 0
        cmp	al, 0
        je	.LBB310_4
.LBB310_3:
        lea	rdx, [rsp + 13]
        mov	rdi, rbx
        mov	esi, 1
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish.2"
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

