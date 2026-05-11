subscribe_converted_flag:
        mov	rax, qword ptr [rdi + 144]
        cmp	rax, offset .Lcodegen_harness.conv_sub_callback
        je	.LBB3_7
        test	rax, rax
        je	.LBB3_2
        mov	rax, qword ptr [rdi + 160]
        add	rdi, 152
        xor	ecx, ecx
        test	rax, rax
        cmovne	rdi, rcx
        jmp	.LBB3_4
.LBB3_2:
        mov	rax, qword ptr [rdi + 160]
        add	rdi, 136
.LBB3_4:
        cmp	rax, offset .Lcodegen_harness.conv_sub_callback
        je	.LBB3_7
        test	rdi, rdi
        je	.LBB3_8
        and	qword ptr [rdi], 0
        mov	qword ptr [rdi + 8], offset .Lcodegen_harness.conv_sub_callback
.LBB3_7:
        ret
.LBB3_8:
        push	rax
        push	19
        pop	rsi
        mov	edi, offset .L__anon_0
        call	.Ldebug.defaultPanic

