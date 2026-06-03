; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal (until 2 calls)
; NOINLINE-PUB. PER-ERD: 2 writes inlined.
;
tiny_write_all:
        push	rbp
        push	rbx
        push	rax
        mov	ebp, edx
        mov	rbx, rdi
        cmp	dword ptr [rdi], esi
        mov	dword ptr [rdi], esi
        je	.L0
        mov	rdi, rbx
        xor	esi, esi
        mov	rdx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish"
.L0:
        and	bpl, 1
        cmp	byte ptr [rbx + 4], bpl
        mov	byte ptr [rbx + 4], bpl
        je	.L1
        mov	rdi, rbx
        mov	esi, 1
        mov	rdx, rbx
        add	rsp, 8
        pop	rbx
        pop	rbp
        jmp	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish"
.L1:
        add	rsp, 8
        pop	rbx
        pop	rbp
        ret

; --- called functions ---

"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish":
        mov	r8, rdx
        movzx	eax, si
        lea	ecx, [8*rax]
        mov	rdx, qword ptr [rcx + __anon_0]
        mov	rcx, qword ptr [rcx + __anon_1]
        add	rcx, rdi
        shl	rdx, 4
        add	rdi, rdx
        add	rdi, 16
        movzx	edx, word ptr [rax + rax + __anon_2]
        mov	esi, 1
        jmp	system_data.publishOnChange

