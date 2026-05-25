; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal (until 2 calls)
; NOINLINE-PUB. Two in-place modifies, each publishes.
;
double_modify_struct:
        push	r14
        push	rbx
        push	rax
        mov	rbx, rdi
        lea	r14, [rdi + 256]
        inc	dword ptr [rdi + 272]
        mov	rsi, r14
        mov	rdx, rdi
        call	".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"
        inc	qword ptr [rbx + 256]
        mov	rdi, rbx
        mov	rsi, r14
        mov	rdx, rbx
        add	rsp, 8
        pop	rbx
        pop	r14
        jmp	".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"

; --- called functions ---

".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish":
        mov	r8, rdx
        mov	rcx, rsi
        add	rdi, 312
        mov	esi, 1
        mov	edx, 1
        jmp	.Lsystem_data.publishOnChange

