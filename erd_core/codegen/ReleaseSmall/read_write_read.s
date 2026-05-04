read_write_read:
        mov	eax, dword ptr [rdi]
        inc	eax
        mov	dword ptr [rdi], eax
        ret

