; snapshot_comments.zig
; Speed: Optimal | Size: Optimal
;
timer_is_active:
        add	rsi, 16
.L0:
        mov	rdi, qword ptr [rdi]
        test	rdi, rdi
        je	.L1
        cmp	rdi, rsi
        jne	.L0
.L1:
        test	rdi, rdi
        setne	al
        ret

