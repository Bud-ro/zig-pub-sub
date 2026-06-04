; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal (until 2 calls)
; NOINLINE-PUB. Two read-modify-writes. ReleaseFast proves each change (branchless publishes); ReleaseSmall calls out-of-line write, retaining the runtime compares.
;
double_rmw_struct:
        push	rbx
        sub	rsp, 48
        mov	rbx, rdi
        mov	eax, dword ptr [rdi + 272]
        mov	ecx, dword ptr [rdi + 276]
        movups	xmm0, xmmword ptr [rdi + 256]
        mov	rsi, rsp
        movaps	xmmword ptr [rsi], xmm0
        inc	eax
        mov	dword ptr [rsi + 16], eax
        mov	dword ptr [rsi + 20], ecx
        call	".Lsystem_data.SystemData(codegen_harness.HugeSystem__struct_0,meta.FieldEnum(codegen_harness.HugeSystem__struct_0),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... }, .medium_no_subs = .{ ... } },system_data_test_double.create.Components).write__anon_1"
        mov	rax, qword ptr [rbx + 256]
        movups	xmm0, xmmword ptr [rbx + 264]
        lea	rsi, [rsp + 24]
        movups	xmmword ptr [rsi + 8], xmm0
        inc	rax
        mov	qword ptr [rsi], rax
        mov	rdi, rbx
        call	".Lsystem_data.SystemData(codegen_harness.HugeSystem__struct_0,meta.FieldEnum(codegen_harness.HugeSystem__struct_0),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... }, .medium_no_subs = .{ ... } },system_data_test_double.create.Components).write__anon_1"
        add	rsp, 48
        pop	rbx
        ret

; --- called functions ---

".Lsystem_data.SystemData(codegen_harness.HugeSystem__struct_0,meta.FieldEnum(codegen_harness.HugeSystem__struct_0),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... }, .medium_no_subs = .{ ... } },system_data_test_double.create.Components).write__anon_1":
        push	r15
        push	r14
        push	rbx
        mov	r15, qword ptr [rdi + 256]
        mov	r11, qword ptr [rdi + 264]
        mov	r9d, dword ptr [rdi + 272]
        movzx	edx, word ptr [rdi + 276]
        movzx	eax, byte ptr [rdi + 278]
        mov	r14, qword ptr [rsi + 8]
        mov	ebx, dword ptr [rsi + 16]
        movzx	r10d, word ptr [rsi + 20]
        movzx	r8d, byte ptr [rsi + 22]
        movzx	ecx, byte ptr [rsi + 23]
        xor	cl, byte ptr [rdi + 279]
        cmp	r15, qword ptr [rsi]
        movups	xmm0, xmmword ptr [rsi]
        movups	xmmword ptr [rdi + 256], xmm0
        mov	rsi, qword ptr [rsi + 16]
        mov	qword ptr [rdi + 272], rsi
        jne	.L0
        cmp	r11, r14
        jne	.L0
        cmp	r9d, ebx
        jne	.L0
        cmp	dx, r10w
        jne	.L0
        cmp	al, r8b
        jne	.L0
        test	cl, 1
        je	.L1
.L0:
        mov	rsi, rdi
        pop	rbx
        pop	r14
        pop	r15
        jmp	".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"
.L1:
        pop	rbx
        pop	r14
        pop	r15
        ret

