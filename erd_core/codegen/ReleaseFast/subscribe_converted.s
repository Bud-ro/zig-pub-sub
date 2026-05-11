subscribe_converted:
        mov	rax, qword ptr [rdi + 112]
        cmp	rax, offset codegen_harness.conv_sub_callback
        je	.LBB253_7
        test	rax, rax
        je	.LBB253_2
        mov	rax, qword ptr [rdi + 128]
        add	rdi, 120
        xor	ecx, ecx
        test	rax, rax
        cmovne	rdi, rcx
        cmp	rax, offset codegen_harness.conv_sub_callback
        jne	.LBB253_5
.LBB253_7:
        ret
.LBB253_2:
        mov	rax, qword ptr [rdi + 128]
        add	rdi, 104
        cmp	rax, offset codegen_harness.conv_sub_callback
        je	.LBB253_7
.LBB253_5:
        test	rdi, rdi
        je	.LBB253_8
        mov	qword ptr [rdi], 0
        mov	qword ptr [rdi + 8], offset codegen_harness.conv_sub_callback
        ret
.LBB253_8:
        push	rax
        mov	edi, offset __anon_0
        mov	esi, 19
        call	debug.defaultPanic

