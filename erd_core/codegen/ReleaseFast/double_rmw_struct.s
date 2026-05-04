double_rmw_struct:
        push	rbp
        mov	rbp, rsp
        push	r14
        push	rbx
        sub	rsp, 32
        mov	rbx, rdi
        mov	eax, dword ptr [rdi + 272]
        mov	ecx, dword ptr [rdi + 276]
        add	eax, 1
        movups	xmm0, xmmword ptr [rdi + 256]
        movaps	xmmword ptr [rbp - 40], xmm0
        mov	dword ptr [rbp - 24], eax
        mov	dword ptr [rbp - 20], ecx
        mov	dword ptr [rdi + 272], eax
        lea	r14, [rbp - 40]
        mov	rsi, r14
        mov	rdx, rdi
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish"
        movups	xmm0, xmmword ptr [rbx + 264]
        mov	rax, qword ptr [rbx + 256]
        add	rax, 1
        mov	qword ptr [rbp - 40], rax
        movups	xmmword ptr [rbp - 32], xmm0
        mov	qword ptr [rbx + 256], rax
        mov	rdi, rbx
        mov	rsi, r14
        mov	rdx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish"
        add	rsp, 32
        pop	rbx
        pop	r14
        pop	rbp
        ret

; --- called functions ---

"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish":
        mov	rax, qword ptr [rdi + 296]
        test	rax, rax
        je	.LBB29_2
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
.LBB29_2:
        ret

