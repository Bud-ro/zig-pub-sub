; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal (until 2 calls)
; NOINLINE-PUB. PER-ERD write + converted read inlined.
;
write_then_read_converted:
        push	rbx
        sub	rsp, 16
        mov	rbx, rdi
        mov	dword ptr [rsp + 12], esi
        cmp	dword ptr [rdi], esi
        mov	dword ptr [rdi], esi
        je	.L0
        lea	rdx, [rsp + 12]
        mov	rdi, rbx
        xor	esi, esi
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(@as([*]const Erd, @ptrCast(&codegen_harness.multi_ram_erds))[0..3]).publish"
.L0:
        mov	rcx, qword ptr [rbx + 136]
        movzx	eax, word ptr [rcx + 5]
        add	eax, dword ptr [rcx]
        add	rsp, 16
        pop	rbx
        ret

; --- called functions ---

"ram_data_component.RamDataComponent(@as([*]const Erd, @ptrCast(&codegen_harness.multi_ram_erds))[0..3]).publish":
        mov	r8, rcx
        mov	rcx, rdx
        movzx	eax, si
        mov	rdx, qword ptr [8*rax + __anon_0]
        movzx	esi, byte ptr [rax + __anon_1]
        shl	rdx, 4
        add	rdi, rdx
        add	rdi, 8
        movzx	edx, word ptr [rax + rax + __anon_2]
        jmp	Subscription.publish

