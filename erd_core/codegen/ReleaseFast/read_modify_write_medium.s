read_modify_write_medium:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 32
        mov	eax, dword ptr [rdi + 272]
        mov	ecx, dword ptr [rdi + 276]
        add	eax, 1
        shl	rcx, 32
        or	rcx, rax
        movups	xmm0, xmmword ptr [rdi + 256]
        movaps	xmmword ptr [rbp - 32], xmm0
        mov	qword ptr [rbp - 16], rcx
        cmp	qword ptr [rdi + 272], rcx
        mov	qword ptr [rdi + 272], rcx
        je	.LBB297_2
        lea	rsi, [rbp - 32]
        mov	rdx, rdi
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish"
.LBB297_2:
        add	rsp, 32
        pop	rbp
        ret

; --- called functions ---

"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish":
        mov	rax, qword ptr [rdi + 296]
        test	rax, rax
        je	.LBB3_2
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        mov	rdi, qword ptr [rdi + 288]
        mov	word ptr [rbp - 8], 1
        mov	qword ptr [rbp - 16], rsi
        lea	rsi, [rbp - 16]
        call	rax
        add	rsp, 16
        pop	rbp
.LBB3_2:
        ret

