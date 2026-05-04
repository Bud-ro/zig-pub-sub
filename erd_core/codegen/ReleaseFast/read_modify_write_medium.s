read_modify_write_medium:
        sub	rsp, 24
        mov	eax, dword ptr [rdi + 272]
        mov	ecx, dword ptr [rdi + 276]
        add	eax, 1
        shl	rcx, 32
        or	rcx, rax
        movups	xmm0, xmmword ptr [rdi + 256]
        movaps	xmmword ptr [rsp], xmm0
        mov	qword ptr [rsp + 16], rcx
        cmp	qword ptr [rdi + 272], rcx
        mov	qword ptr [rdi + 272], rcx
        je	.LBB25_2
        mov	rsi, rsp
        mov	rdx, rdi
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish"
.LBB25_2:
        add	rsp, 24
        ret

; --- called functions ---

"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish":
        mov	rax, qword ptr [rdi + 296]
        test	rax, rax
        je	.LBB3_2
        sub	rsp, 24
        mov	rdi, qword ptr [rdi + 288]
        mov	word ptr [rsp + 16], 1
        mov	qword ptr [rsp + 8], rsi
        lea	rsi, [rsp + 8]
        call	rax
        add	rsp, 24
.LBB3_2:
        ret

