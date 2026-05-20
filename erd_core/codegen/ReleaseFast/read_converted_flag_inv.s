read_converted_flag_inv:
        mov	rax, qword ptr [rdi + 168]
        movzx	eax, byte ptr [rax + 4]
        xor	al, 1
        ret

