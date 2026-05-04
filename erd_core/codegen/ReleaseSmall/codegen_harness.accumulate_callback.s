codegen_harness.accumulate_callback:
        push	rbp
        mov	rbp, rsp
        mov	rax, qword ptr [rsi]
        cmp	byte ptr [rax], 0
        je	.LBB43_2
        inc	dword ptr [rdx]
.LBB43_2:
        pop	rbp
        ret

