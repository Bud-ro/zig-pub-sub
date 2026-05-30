; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal (until 2 calls)
; NOINLINE-PUB + LLVM reload: after the first publish call,
; LLVM conservatively reloads the stored value because it
; cannot prove publish did not mutate it through the opaque
; publisher pointer.
;
double_write_same_value:
        push	rbx
        sub	rsp, 16
        mov	rbx, rdi
        cmp	byte ptr [rdi + 4], 1
        mov	byte ptr [rdi + 4], 1
        je	.L0
        mov	rdi, rbx
        mov	esi, 1
        mov	rdx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish.2"
        movzx	eax, byte ptr [rbx + 4]
        mov	byte ptr [rbx + 4], 1
        cmp	al, 1
        je	.L1
.L2:
        mov	rdi, rbx
        mov	esi, 1
        mov	rdx, rbx
        add	rsp, 16
        pop	rbx
        jmp	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish.2"
.L0:
        mov	al, 1
        mov	byte ptr [rbx + 4], 1
        cmp	al, 1
        jne	.L2
.L1:
        add	rsp, 16
        pop	rbx
        ret

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

