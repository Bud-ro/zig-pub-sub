read_ram_then_converted:
        mov	rcx, qword ptr [rdi + 168]
        mov	eax, dword ptr [rcx]
        movzx	ecx, word ptr [rcx + 5]
        add	eax, dword ptr [rdi]
        add	eax, ecx
        ret

