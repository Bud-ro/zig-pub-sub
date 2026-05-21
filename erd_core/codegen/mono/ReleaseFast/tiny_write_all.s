; snapshot_comments.zig
; Speed: Optimal | Size: Optimal (until 2 calls)
;
tiny_write_all:
        push	rbp
        push	rbx
        sub	rsp, 24
        mov	ebp, edx
        mov	rbx, rdi
        mov	dword ptr [rsp + 16], esi
        cmp	dword ptr [rdi], esi
        mov	dword ptr [rdi], esi
        je	.L0
        lea	rdx, [rsp + 16]
        mov	rdi, rbx
        xor	esi, esi
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish"
.L0:
        and	bpl, 1
        mov	byte ptr [rsp + 15], bpl
        cmp	byte ptr [rbx + 4], bpl
        mov	byte ptr [rbx + 4], bpl
        je	.L1
        lea	rdx, [rsp + 15]
        mov	rdi, rbx
        mov	esi, 1
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish"
.L1:
        add	rsp, 24
        pop	rbx
        pop	rbp
        ret

; --- called functions ---

"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish":
        mov	r8, rcx
        mov	rcx, rdx
        movzx	eax, si
        mov	rdx, qword ptr [8*rax + __anon_2]
        shl	rdx, 4
        add	rdi, rdx
        add	rdi, 16
        movzx	edx, word ptr [rax + rax + __anon_3]
        mov	esi, 1
        jmp	Subscription.publish

