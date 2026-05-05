write_medium_with_subs:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 32
        mov	rcx, qword ptr [rsi]
        mov	rdx, qword ptr [rsi + 8]
        mov	rax, qword ptr [rsi + 16]
        mov	qword ptr [rbp - 24], rcx
        mov	qword ptr [rbp - 16], rdx
        mov	qword ptr [rbp - 8], rax
        cmp	qword ptr [rdi + 256], rcx
        jne	.LBB298_2
        cmp	qword ptr [rdi + 264], rdx
        jne	.LBB298_2
        cmp	qword ptr [rdi + 272], rax
        mov	qword ptr [rdi + 256], rcx
        mov	qword ptr [rdi + 272], rax
        jne	.LBB298_4
        add	rsp, 32
        pop	rbp
        ret
.LBB298_2:
        mov	qword ptr [rdi + 256], rcx
        mov	qword ptr [rdi + 264], rdx
        mov	qword ptr [rdi + 272], rax
.LBB298_4:
        lea	rsi, [rbp - 24]
        mov	rdx, rdi
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish"
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

