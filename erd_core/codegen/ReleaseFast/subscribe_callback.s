subscribe_callback:
        mov	rax, qword ptr [rdi + 24]
        cmp	rax, offset codegen_harness.accumulate_callback
        je	.LBB17_3
        test	rax, rax
        jne	.LBB17_4
        mov	qword ptr [rdi + 16], 0
        mov	qword ptr [rdi + 24], offset codegen_harness.accumulate_callback
.LBB17_3:
        ret
.LBB17_4:
        push	rbp
        mov	rbp, rsp
        mov	edi, offset __anon_2412
        mov	esi, 19
        call	debug.defaultPanic

