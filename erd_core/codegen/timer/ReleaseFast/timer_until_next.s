; snapshot_comments.zig
; Speed: Optimal | Size: Optimal
;
timer_until_next:
        mov	rax, qword ptr [rdi]
        test	rax, rax
        je	.L0
        mov	ecx, dword ptr [rdi + 16]
        mov	edx, dword ptr [rax + 8]
        sub	edx, ecx
        xor	eax, eax
        cmp	edx, -65535
        cmovb	eax, edx
        ret
.L0:
        mov	eax, -1
        ret

