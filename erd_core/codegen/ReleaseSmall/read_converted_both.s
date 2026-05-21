; snapshot_comments.zig
; Speed: Optimal | Size: Optimal (until 2 calls)
;
read_converted_both:
        mov	rax, qword ptr [rdi + 168]
        movzx	ecx, word ptr [rax + 5]
        add	ecx, dword ptr [rax]
        mov	eax, dword ptr [rax + 4]
        not	eax
        and	eax, 1
        add	eax, ecx
        ret

