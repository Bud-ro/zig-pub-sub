write_medium_with_subs:
        sub	rsp, 24
        mov	rcx, qword ptr [rsi]
        mov	rdx, qword ptr [rsi + 8]
        mov	rax, qword ptr [rsi + 16]
        mov	qword ptr [rsp], rcx
        mov	qword ptr [rsp + 8], rdx
        mov	qword ptr [rsp + 16], rax
        cmp	qword ptr [rdi + 256], rcx
        jne	.LBB298_2
        cmp	qword ptr [rdi + 264], rdx
        jne	.LBB298_2
        cmp	qword ptr [rdi + 272], rax
        mov	qword ptr [rdi + 256], rcx
        mov	qword ptr [rdi + 272], rax
        jne	.LBB298_4
        add	rsp, 24
        ret
.LBB298_2:
        mov	qword ptr [rdi + 256], rcx
        mov	qword ptr [rdi + 264], rdx
        mov	qword ptr [rdi + 272], rax
.LBB298_4:
        mov	rsi, rsp
        mov	rdx, rdi
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish"
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

