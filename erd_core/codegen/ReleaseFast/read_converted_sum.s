read_converted_sum:
        push	rax
        mov	rax, rdi
        mov	rsi, qword ptr [rdi + 168]
        lea	rdi, [rsp + 4]
        call	qword ptr [rax + 88]
        mov	eax, dword ptr [rsp + 4]
        pop	rcx
        ret

