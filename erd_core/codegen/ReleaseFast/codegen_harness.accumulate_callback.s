codegen_harness.accumulate_callback:
        push	rbp
        mov	rbp, rsp
        mov	rax, qword ptr [rsi]
        cmp	byte ptr [rax], 0
        je	.LBB40_2
        add	dword ptr [rdx], 1
.LBB40_2:
        pop	rbp
        ret

