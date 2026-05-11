read_indirect_computed:
        push	rax
        mov	rax, rdi
        lea	rdi, [rsp + 6]
        call	qword ptr [rax + 80]
        movzx	eax, word ptr [rsp + 6]
        pop	rcx
        ret

