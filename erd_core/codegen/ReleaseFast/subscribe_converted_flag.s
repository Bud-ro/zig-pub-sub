subscribe_converted_flag:
        mov	rax, qword ptr [rdi + 144]
        cmp	rax, offset codegen_harness.conv_sub_callback
        je	.LBB3_7
        test	rax, rax
        je	.LBB3_2
        mov	rax, qword ptr [rdi + 160]
        add	rdi, 152
        xor	ecx, ecx
        test	rax, rax
        cmovne	rdi, rcx
        cmp	rax, offset codegen_harness.conv_sub_callback
        jne	.LBB3_5
.LBB3_7:
        ret
.LBB3_2:
        mov	rax, qword ptr [rdi + 160]
        add	rdi, 136
        cmp	rax, offset codegen_harness.conv_sub_callback
        je	.LBB3_7
.LBB3_5:
        test	rdi, rdi
        je	.LBB3_8
        mov	qword ptr [rdi], 0
        mov	qword ptr [rdi + 8], offset codegen_harness.conv_sub_callback
        ret
.LBB3_8:
        push	rax
        mov	edi, offset __anon_0
        mov	esi, 19
        call	debug.defaultPanic

