; snapshot_comments.zig
; Speed: Optimal | Size: Optimal
;
read_all_component_types:
        mov	eax, dword ptr [rdi]
        mov	rcx, qword ptr [rdi + 168]
        movzx	edx, word ptr [rcx + 5]
        add	eax, dword ptr [rcx]
        add	eax, edx
        add	eax, 51966
        ret

