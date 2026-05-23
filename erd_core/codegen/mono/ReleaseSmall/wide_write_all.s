; snapshot_comments.zig
; Speed: Near-optimal | Size: Suboptimal
; NOINLINE-PUB. PER-ERD: 8 subscribable writes plus 8 non-subscribable
; stores, all monomorphized inline. 358 bytes RF / 311 bytes RS.
; Size is not optimal: the runtime-dispatch counterpart
; wide_runtime_write_all is 264 bytes RF / 40 bytes RS using the same
; shared runtimeWrite path, so a memcpy-and-publish helper produces
; dramatically smaller code. The size cost here is the deliberate
; trade for the comptime-typed, per-ERD write API: callers get
; static type checks and PER-ERD store widths in exchange for ROM.
;
wide_write_all:
        push	rbx
        sub	rsp, 16
        mov	rbx, rdi
        mov	al, 1
        mov	byte ptr [rsp], al
        cmp	byte ptr [rdi], al
        mov	byte ptr [rdi], al
        je	.L0
        mov	rdx, rsp
        mov	rdi, rbx
        xor	esi, esi
        mov	rcx, rbx
        call	".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).publish"
.L0:
        mov	word ptr [rbx + 1], 2
        push	3
        pop	rax
        mov	dword ptr [rsp], eax
        cmp	dword ptr [rbx + 3], eax
        mov	dword ptr [rbx + 3], eax
        je	.L1
        push	2
        pop	rsi
        mov	rdx, rsp
        mov	rdi, rbx
        mov	rcx, rbx
        call	".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).publish"
.L1:
        mov	qword ptr [rbx + 7], 4
        mov	byte ptr [rbx + 15], 5
        mov	ax, 6
        mov	word ptr [rsp], ax
        cmp	word ptr [rbx + 16], ax
        mov	word ptr [rbx + 16], ax
        je	.L2
        push	5
        pop	rsi
        mov	rdx, rsp
        mov	rdi, rbx
        mov	rcx, rbx
        call	".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).publish"
.L2:
        mov	dword ptr [rbx + 18], 7
        push	8
        pop	rax
        mov	qword ptr [rsp], rax
        cmp	qword ptr [rbx + 22], rax
        mov	qword ptr [rbx + 22], rax
        je	.L3
        push	7
        pop	rsi
        mov	rdx, rsp
        mov	rdi, rbx
        mov	rcx, rbx
        call	".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).publish"
.L3:
        mov	byte ptr [rbx + 30], 1
        mov	al, 9
        mov	byte ptr [rsp], al
        cmp	byte ptr [rbx + 31], al
        mov	byte ptr [rbx + 31], al
        je	.L4
        push	9
        pop	rsi
        mov	rdx, rsp
        mov	rdi, rbx
        mov	rcx, rbx
        call	".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).publish"
.L4:
        mov	word ptr [rbx + 32], 10
        push	11
        pop	rax
        mov	dword ptr [rsp], eax
        cmp	dword ptr [rbx + 34], eax
        mov	dword ptr [rbx + 34], eax
        je	.L5
        push	11
        pop	rsi
        mov	rdx, rsp
        mov	rdi, rbx
        mov	rcx, rbx
        call	".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).publish"
.L5:
        mov	qword ptr [rbx + 38], 12
        push	13
        pop	rax
        mov	dword ptr [rsp], eax
        cmp	dword ptr [rbx + 46], eax
        mov	dword ptr [rbx + 46], eax
        je	.L6
        push	13
        pop	rsi
        mov	rdx, rsp
        mov	rdi, rbx
        mov	rcx, rbx
        call	".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).publish"
.L6:
        mov	byte ptr [rbx + 50], 0
        push	14
        pop	rax
        mov	dword ptr [rsp], eax
        cmp	dword ptr [rbx + 51], eax
        mov	dword ptr [rbx + 51], eax
        je	.L7
        push	15
        pop	rsi
        mov	rdx, rsp
        mov	rdi, rbx
        mov	rcx, rbx
        call	".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).publish"
.L7:
        add	rsp, 16
        pop	rbx
        ret

; --- called functions ---

".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).publish":
        mov	r8, rcx
        mov	rcx, rdx
        movzx	eax, si
        mov	rdx, qword ptr [8*rax + .L__anon_8]
        movzx	esi, byte ptr [rax + .L__anon_9]
        shl	rdx, 4
        add	rdi, rdx
        add	rdi, 64
        movzx	edx, word ptr [rax + rax + .L__anon_10]
        jmp	.LSubscription.publish

