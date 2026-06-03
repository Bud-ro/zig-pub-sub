; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal (until 2 calls)
; NOINLINE-PUB. PER-ERD: three writes.
;
triple_write_increment:
        push	rbx
        mov	rbx, rdi
        cmp	word ptr [rdi + 8], 1
        mov	word ptr [rdi + 8], 1
        je	.L0
        mov	rdi, rbx
        mov	esi, 3
        mov	rdx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish.2"
        cmp	word ptr [rbx + 8], 2
        mov	word ptr [rbx + 8], 2
        je	.L1
.L2:
        mov	rdi, rbx
        mov	esi, 3
        mov	rdx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish.2"
        cmp	word ptr [rbx + 8], 3
        mov	word ptr [rbx + 8], 3
        je	.L3
.L4:
        mov	rdi, rbx
        mov	esi, 3
        mov	rdx, rbx
        pop	rbx
        jmp	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish.2"
.L1:
        mov	word ptr [rbx + 8], 3
        jmp	.L4
.L3:
        pop	rbx
        ret
.L0:
        mov	word ptr [rbx + 8], 2
        jmp	.L2

; --- called functions ---

"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish.2":
        mov	r8, rdx
        movzx	eax, si
        movzx	esi, byte ptr [rax + __anon_0]
        movzx	edx, word ptr [rax + rax + __anon_1]
        shl	eax, 3
        mov	r9, qword ptr [rax + __anon_2]
        mov	rcx, qword ptr [rax + __anon_3]
        add	rcx, rdi
        shl	r9, 4
        add	rdi, r9
        add	rdi, 16
        jmp	system_data.publishOnChange

