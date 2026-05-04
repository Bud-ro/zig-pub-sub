read_then_branch:
        mov	eax, dword ptr [rdi]
        mov	ecx, eax
        imul	ecx, eax
        add	eax, eax
        test	sil, 1
        cmove	eax, ecx
        ret

