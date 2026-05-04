write_medium_with_subs:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 32
        mov	rax, qword ptr [rsi + 16]
        mov	qword ptr [rbp - 16], rax
        movups	xmm0, xmmword ptr [rsi]
        movaps	xmmword ptr [rbp - 32], xmm0
        mov	r10, qword ptr [rdi + 256]
        mov	r9, qword ptr [rdi + 264]
        mov	r8d, dword ptr [rdi + 272]
        movzx	edx, word ptr [rdi + 276]
        movzx	ecx, byte ptr [rdi + 278]
        movzx	eax, byte ptr [rdi + 279]
        movups	xmm0, xmmword ptr [rsi]
        mov	r11, qword ptr [rsi + 16]
        mov	qword ptr [rdi + 272], r11
        movups	xmmword ptr [rdi + 256], xmm0
        cmp	r10, qword ptr [rsi]
        jne	.LBB28_6
        cmp	r9, qword ptr [rsi + 8]
        jne	.LBB28_6
        cmp	r8d, dword ptr [rsi + 16]
        jne	.LBB28_6
        cmp	dx, word ptr [rsi + 20]
        jne	.LBB28_6
        cmp	cl, byte ptr [rsi + 22]
        jne	.LBB28_6
        and	al, 1
        cmp	byte ptr [rsi + 23], al
        je	.LBB28_7
.LBB28_6:
        lea	rsi, [rbp - 32]
        mov	rdx, rdi
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish"
.LBB28_7:
        add	rsp, 32
        pop	rbp
        ret

; --- called functions ---

"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish":
        mov	rax, qword ptr [rdi + 296]
        test	rax, rax
        je	.LBB29_2
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        mov	rdi, qword ptr [rdi + 288]
        mov	word ptr [rbp - 8], 1
        mov	qword ptr [rbp - 16], rsi
        lea	rsi, [rbp - 16]
        call	rax
        add	rsp, 16
        pop	rbp
.LBB29_2:
        ret

