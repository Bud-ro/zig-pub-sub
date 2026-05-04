codegen_subscribe_callback:
        mov	rax, qword ptr [rdi + 24]
        cmp	rax, offset codegen_harness.accumulate_callback
        je	.LBB42_3
        test	rax, rax
        jne	.LBB42_4
        and	qword ptr [rdi + 16], 0
        mov	qword ptr [rdi + 24], offset codegen_harness.accumulate_callback
.LBB42_3:
        ret
.LBB42_4:
        push	rbp
        mov	rbp, rsp
        call	debug.defaultPanic

