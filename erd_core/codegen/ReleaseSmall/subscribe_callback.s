subscribe_callback:
        mov	rax, qword ptr [rdi + 24]
        cmp	rax, offset .Lcodegen_harness.accumulate_callback
        je	.LBB20_3
        test	rax, rax
        jne	.LBB20_4
        and	qword ptr [rdi + 16], 0
        mov	qword ptr [rdi + 24], offset .Lcodegen_harness.accumulate_callback
.LBB20_3:
        ret
.LBB20_4:
        push	rbp
        mov	rbp, rsp
        push	19
        pop	rsi
        mov	edi, offset .L__anon_2413
        call	.Ldebug.defaultPanic

