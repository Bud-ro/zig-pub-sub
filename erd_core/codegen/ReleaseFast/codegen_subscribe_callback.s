codegen_subscribe_callback:
        mov	rax, qword ptr [rdi + 24]
        cmp	rax, offset codegen_harness.accumulate_callback
        je	.LBB39_3
        test	rax, rax
        jne	.LBB39_4
        mov	qword ptr [rdi + 16], 0
        mov	qword ptr [rdi + 24], offset codegen_harness.accumulate_callback
.LBB39_3:
        ret
.LBB39_4:
        push	rbp
        mov	rbp, rsp
        call	debug.defaultPanic

