subscribe_converted:
        mov	rax, qword ptr [rdi + 112]
        cmp	rax, offset .Lcodegen_harness.conv_sub_callback
        je	.LBB249_7
        test	rax, rax
        je	.LBB249_2
        mov	rax, qword ptr [rdi + 128]
        add	rdi, 120
        xor	ecx, ecx
        test	rax, rax
        cmovne	rdi, rcx
        jmp	.LBB249_4
.LBB249_2:
        mov	rax, qword ptr [rdi + 128]
        add	rdi, 104
.LBB249_4:
        cmp	rax, offset .Lcodegen_harness.conv_sub_callback
        je	.LBB249_7
        test	rdi, rdi
        je	.LBB249_8
        and	qword ptr [rdi], 0
        mov	qword ptr [rdi + 8], offset .Lcodegen_harness.conv_sub_callback
.LBB249_7:
        ret
.LBB249_8:
        push	rax
        push	19
        pop	rsi
        mov	edi, offset .L__anon_0
        call	.Ldebug.defaultPanic

