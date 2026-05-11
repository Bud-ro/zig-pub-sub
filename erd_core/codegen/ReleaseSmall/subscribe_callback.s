subscribe_callback:
        mov	rax, qword ptr [rdi + 24]
        cmp	rax, offset .Lcodegen_harness.accumulate_callback
        je	.LBB306_3
        test	rax, rax
        jne	.LBB306_4
        and	qword ptr [rdi + 16], 0
        mov	qword ptr [rdi + 24], offset .Lcodegen_harness.accumulate_callback
.LBB306_3:
        ret
.LBB306_4:
        push	rax
        push	19
        pop	rsi
        mov	edi, offset .L__anon_0
        call	.Ldebug.defaultPanic

