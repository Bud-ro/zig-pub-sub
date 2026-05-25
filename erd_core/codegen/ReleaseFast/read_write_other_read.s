; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal (until 2 calls)
; NOINLINE-PUB. PER-ERD: 58 bytes, write portion inlined.
;
read_write_other_read:
        push	rbp
        push	rbx
        push	rax
        mov	ebp, dword ptr [rdi]
        and	sil, 1
        mov	byte ptr [rsp + 6], sil
        mov	eax, ebp
        cmp	byte ptr [rdi + 4], sil
        mov	byte ptr [rdi + 4], sil
        je	.L0
        lea	rdx, [rsp + 6]
        mov	rbx, rdi
        mov	esi, 1
        mov	rcx, rdi
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish.2"
        mov	eax, dword ptr [rbx]
.L0:
        add	eax, ebp
        add	rsp, 8
        pop	rbx
        pop	rbp
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
        jmp	system_data.publishOnChange

