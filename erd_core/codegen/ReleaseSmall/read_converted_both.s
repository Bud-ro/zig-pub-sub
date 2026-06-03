; snapshot_comments.zig
; Speed: Optimal | Size: Optimal (until 2 calls)
; PER-ERD: two converted reads, each unique compute function.
;
read_converted_both:
        mov	rax, qword ptr [rdi + 136]
        movzx	ecx, word ptr [rax + 6]
        add	ecx, dword ptr [rax]
        mov	eax, dword ptr [rax + 4]
        not	eax
        and	eax, 1
        add	eax, ecx
        ret

