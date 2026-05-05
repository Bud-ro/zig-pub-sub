many_write_last_with_subs:
        push	rax
        mov	qword ptr [rsp], rsi
        cmp	qword ptr [rdi + 112], rsi
        mov	qword ptr [rdi + 112], rsi
        je	.LBB298_2
        mov	rsi, rsp
        mov	rdx, rdi
        call	".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..32]).publish"
.LBB298_2:
        pop	rax
        ret

; --- called functions ---

".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..32]).publish":
        push	r15
        push	r14
        push	rbx
        sub	rsp, 16
        mov	rbx, rdx
        mov	r14, rsi
        mov	r15, rdi
        mov	rax, qword ptr [rdi + 144]
        test	rax, rax
        je	.LBB299_1
        mov	rdi, qword ptr [r15 + 136]
        mov	word ptr [rsp + 8], 31
        mov	qword ptr [rsp], r14
        mov	rsi, rsp
        mov	rdx, rbx
        call	rax
.LBB299_1:
        mov	rax, qword ptr [r15 + 160]
        test	rax, rax
        je	.LBB299_3
        mov	rdi, qword ptr [r15 + 152]
        mov	word ptr [rsp + 8], 31
        mov	qword ptr [rsp], r14
        mov	rsi, rsp
        mov	rdx, rbx
        call	rax
.LBB299_3:
        mov	rax, qword ptr [r15 + 176]
        test	rax, rax
        je	.LBB299_5
        mov	rdi, qword ptr [r15 + 168]
        mov	word ptr [rsp + 8], 31
        mov	qword ptr [rsp], r14
        mov	rsi, rsp
        mov	rdx, rbx
        call	rax
.LBB299_5:
        add	rsp, 16
        pop	rbx
        pop	r14
        pop	r15
        ret

