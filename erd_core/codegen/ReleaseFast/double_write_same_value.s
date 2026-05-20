double_write_same_value:
        push	rbx
        sub	rsp, 16
        mov	rbx, rdi
        mov	byte ptr [rsp + 12], 1
        mov	al, 1
        cmp	byte ptr [rdi + 4], 1
        mov	byte ptr [rdi + 4], 1
        jne	.LBB311_1
        mov	byte ptr [rsp + 13], 1
        mov	byte ptr [rbx + 4], 1
        cmp	al, 1
        jne	.LBB311_3
.LBB311_4:
        add	rsp, 16
        pop	rbx
        ret
.LBB311_1:
        lea	rdx, [rsp + 12]
        mov	rdi, rbx
        mov	esi, 1
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish.2"
        movzx	eax, byte ptr [rbx + 4]
        mov	byte ptr [rsp + 13], 1
        mov	byte ptr [rbx + 4], 1
        cmp	al, 1
        je	.LBB311_4
.LBB311_3:
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

