; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal
; Tagged union: swap the active variant payload based on the runtime tag.
;
wire_swap_reading:
        push	8
        pop	rsi
        jmp	".Lerd_swap.SwapRules(codegen_wire_publisher.Reading).applyToBig"

; --- called functions ---

".Lerd_swap.SwapRules(codegen_wire_publisher.Reading).applyToBig":
        push	r14
        push	rbx
        push	rax
        mov	r14, rsi
        mov	rbx, rdi
        mov	edi, offset .L__anon_0
        mov	esi, 3
        mov	edx, offset .L__anon_0
        mov	ecx, 3
        call	.Lmem.eql__anon_1
        test	r14, r14
        setne	cl
        and	cl, al
        cmp	cl, 1
        jne	.L0
        movzx	eax, byte ptr [rbx]
        cmp	eax, 1
        je	.L1
        test	eax, eax
        jne	.L0
        cmp	r14, 8
        jb	.L0
        mov	eax, dword ptr [rbx + 4]
        bswap	eax
        mov	dword ptr [rbx + 4], eax
.L0:
        add	rsp, 8
        pop	rbx
        pop	r14
        ret
.L1:
        cmp	r14, 6
        jb	.L0
        rol	word ptr [rbx + 4], 8
        add	rsp, 8
        pop	rbx
        pop	r14
        ret

