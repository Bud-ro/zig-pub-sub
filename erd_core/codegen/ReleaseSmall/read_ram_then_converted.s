; snapshot_comments.zig
; Speed: Optimal | Size: Optimal (until 2 calls)
; PER-ERD: RAM load + converted compute inlined.
;
read_ram_then_converted:
        mov	rcx, qword ptr [rdi + 136]
        mov	eax, dword ptr [rcx]
        movzx	ecx, word ptr [rcx + 5]
        add	eax, dword ptr [rdi]
        add	eax, ecx
        ret

