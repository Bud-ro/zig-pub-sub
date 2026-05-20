write_then_read_converted:
        push	rbx
        sub	rsp, 16
        mov	rbx, rdi
        mov	dword ptr [rsp + 8], esi
        cmp	dword ptr [rdi], esi
        mov	dword ptr [rdi], esi
        je	.L0
        lea	rdx, [rsp + 8]
        mov	rdi, rbx
        xor	esi, esi
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(@as([*]const Erd, @ptrCast(&codegen_harness.ram_defs))[0..3]).publish"
.L0:
        mov	rsi, qword ptr [rbx + 168]
        lea	rdi, [rsp + 12]
        call	qword ptr [rbx + 88]
        mov	eax, dword ptr [rsp + 12]
        add	rsp, 16
        pop	rbx
        ret

; --- called functions ---

"ram_data_component.RamDataComponent(@as([*]const Erd, @ptrCast(&codegen_harness.ram_defs))[0..3]).publish":
        mov	r8, rcx
        mov	rcx, rdx
        movzx	eax, si
        mov	rdx, qword ptr [8*rax + __anon_1]
        movzx	esi, byte ptr [rax + __anon_2]
        shl	rdx, 4
        add	rdi, rdx
        add	rdi, 8
        movzx	edx, word ptr [rax + rax + __anon_3]
        jmp	Subscription.publish

