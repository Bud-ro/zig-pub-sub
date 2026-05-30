; snapshot_comments.zig
; Speed: Near-optimal | Size: Suboptimal
; NOINLINE-PUB. PER-ERD: 8 subscribable writes plus 8 non-subscribable
; stores, all monomorphized inline. 422 bytes RF / 275 bytes RS.
; Since publish reads the value back from storage, the 8 publish calls
; are now uniform (just an index), so ReleaseFast sinks them into a
; forward jne chain and tail-duplicates the change-checks to keep the
; all-unchanged hot path tight -- a deliberate speed-for-size trade that
; grows RF but lets ReleaseSmall (which declines the duplication) shrink.
; Size is still not optimal: the runtime-dispatch counterpart
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
        cmp	byte ptr [rdi], 1
        mov	byte ptr [rdi], 1
        je	.L0
        mov	rdi, rbx
        xor	esi, esi
        mov	rdx, rbx
        call	".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).publish"
.L0:
        mov	word ptr [rbx + 2], 2
        cmp	dword ptr [rbx + 4], 3
        mov	dword ptr [rbx + 4], 3
        je	.L1
        push	2
        pop	rsi
        mov	rdi, rbx
        mov	rdx, rbx
        call	".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).publish"
.L1:
        mov	qword ptr [rbx + 8], 4
        mov	byte ptr [rbx + 16], 5
        cmp	word ptr [rbx + 18], 6
        mov	word ptr [rbx + 18], 6
        je	.L2
        push	5
        pop	rsi
        mov	rdi, rbx
        mov	rdx, rbx
        call	".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).publish"
.L2:
        mov	dword ptr [rbx + 20], 7
        cmp	qword ptr [rbx + 24], 8
        mov	qword ptr [rbx + 24], 8
        je	.L3
        push	7
        pop	rsi
        mov	rdi, rbx
        mov	rdx, rbx
        call	".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).publish"
.L3:
        mov	byte ptr [rbx + 32], 1
        cmp	byte ptr [rbx + 33], 9
        mov	byte ptr [rbx + 33], 9
        je	.L4
        push	9
        pop	rsi
        mov	rdi, rbx
        mov	rdx, rbx
        call	".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).publish"
.L4:
        mov	word ptr [rbx + 34], 10
        cmp	dword ptr [rbx + 36], 11
        mov	dword ptr [rbx + 36], 11
        je	.L5
        push	11
        pop	rsi
        mov	rdi, rbx
        mov	rdx, rbx
        call	".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).publish"
.L5:
        mov	qword ptr [rbx + 40], 12
        cmp	dword ptr [rbx + 48], 13
        mov	dword ptr [rbx + 48], 13
        je	.L6
        push	13
        pop	rsi
        mov	rdi, rbx
        mov	rdx, rbx
        call	".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).publish"
.L6:
        mov	byte ptr [rbx + 52], 0
        cmp	dword ptr [rbx + 56], 14
        mov	dword ptr [rbx + 56], 14
        je	.L7
        push	15
        pop	rsi
        mov	rdi, rbx
        mov	rdx, rbx
        add	rsp, 16
        pop	rbx
        jmp	".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).publish"
.L7:
        add	rsp, 16
        pop	rbx
        ret

; --- called functions ---

".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).publish":
        mov	r8, rdx
        movzx	eax, si
        movzx	esi, byte ptr [rax + .L__anon_0]
        movzx	edx, word ptr [rax + rax + .L__anon_1]
        shl	eax, 3
        mov	r9, qword ptr [rax + .L__anon_2]
        mov	rcx, qword ptr [rax + .L__anon_3]
        add	rcx, rdi
        shl	r9, 4
        add	rdi, r9
        add	rdi, 72
        jmp	.Lsystem_data.publishOnChange

