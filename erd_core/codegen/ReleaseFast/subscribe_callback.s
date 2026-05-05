subscribe_callback:
        mov	rax, qword ptr [rdi + 24]
        cmp	rax, offset codegen_harness.accumulate_callback
        je	.LBB20_3
        test	rax, rax
        jne	.LBB20_4
        mov	qword ptr [rdi + 16], 0
        mov	qword ptr [rdi + 24], offset codegen_harness.accumulate_callback
.LBB20_3:
        ret
.LBB20_4:
        push	rax
        mov	edi, offset __anon_0
        mov	esi, 19
        call	debug.defaultPanic

