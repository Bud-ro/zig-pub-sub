codegen_increment_n_times:
        push	rbp
        mov	rbp, rsp
.LBB59_1:
        cmp	esi, 1
        jb	.LBB59_3
        inc	dword ptr [rdi]
        dec	esi
        jmp	.LBB59_1
.LBB59_3:
        pop	rbp
        ret

