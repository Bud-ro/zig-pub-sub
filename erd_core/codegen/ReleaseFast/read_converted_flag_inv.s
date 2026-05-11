read_converted_flag_inv:
        push	rax
        mov	rax, rdi
        mov	rsi, qword ptr [rdi + 168]
        lea	rdi, [rsp + 7]
        call	qword ptr [rax + 96]
        movzx	eax, byte ptr [rsp + 7]
        pop	rcx
        ret

