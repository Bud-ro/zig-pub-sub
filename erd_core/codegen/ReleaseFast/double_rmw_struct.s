double_rmw_struct:
        push	rbp
        mov	rbp, rsp
        push	rbx
        sub	rsp, 24
        mov	rbx, rdi
        mov	rax, qword ptr [rdi + 256]
        mov	rcx, qword ptr [rdi + 264]
        mov	esi, dword ptr [rdi + 272]
        add	esi, 1
        mov	edx, dword ptr [rdi + 276]
        shl	rdx, 32
        or	rdx, rsi
        mov	qword ptr [rbp - 32], rax
        mov	qword ptr [rbp - 24], rcx
        mov	qword ptr [rbp - 16], rdx
        cmp	qword ptr [rdi + 272], rdx
        mov	qword ptr [rdi + 272], rdx
        je	.LBB2_2
        lea	rsi, [rbp - 32]
        mov	rdi, rbx
        mov	rdx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish"
        mov	rax, qword ptr [rbx + 256]
        mov	rcx, qword ptr [rbx + 264]
        mov	rdx, qword ptr [rbx + 272]
.LBB2_2:
        add	rax, 1
        mov	qword ptr [rbp - 32], rax
        mov	qword ptr [rbp - 24], rcx
        mov	qword ptr [rbp - 16], rdx
        mov	qword ptr [rbx + 256], rax
        mov	qword ptr [rbx + 272], rdx
        lea	rsi, [rbp - 32]
        mov	rdi, rbx
        mov	rdx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish"
        add	rsp, 24
        pop	rbx
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

