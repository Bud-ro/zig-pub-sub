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
        call	".Lsystem_data.SystemData(codegen_harness.HugeSystem__struct_0,meta.FieldEnum(codegen_harness.HugeSystem__struct_0),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },system_data_test_double.create.Components).write__anon_1"
        mov	rax, qword ptr [rbx + 256]
        movups	xmm0, xmmword ptr [rbx + 264]
        lea	rsi, [rsp + 24]
        movups	xmmword ptr [rsi + 8], xmm0
        inc	rax
        mov	qword ptr [rsi], rax
        mov	rdi, rbx
        call	".Lsystem_data.SystemData(codegen_harness.HugeSystem__struct_0,meta.FieldEnum(codegen_harness.HugeSystem__struct_0),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },system_data_test_double.create.Components).write__anon_1"
        add	rsp, 48
        pop	rbx
        ret

; --- called functions ---

".Lsystem_data.SystemData(codegen_harness.HugeSystem__struct_0,meta.FieldEnum(codegen_harness.HugeSystem__struct_0),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },system_data_test_double.create.Components).write__anon_1":
        sub	rsp, 24
        mov	rax, qword ptr [rsi + 16]
        mov	qword ptr [rsp + 16], rax
        movups	xmm0, xmmword ptr [rsi]
        movaps	xmmword ptr [rsp], xmm0
        mov	rcx, qword ptr [rsi]
        mov	rdx, qword ptr [rsi + 8]
        mov	rax, qword ptr [rsi + 16]
        cmp	qword ptr [rdi + 256], rcx
        jne	.LBB3_2
        cmp	qword ptr [rdi + 264], rdx
        jne	.LBB3_2
        cmp	qword ptr [rdi + 272], rax
        mov	qword ptr [rdi + 256], rcx
        mov	qword ptr [rdi + 272], rax
        jne	.LBB3_4
        add	rsp, 24
        ret
.LBB3_2:
        mov	qword ptr [rdi + 256], rcx
        mov	qword ptr [rdi + 264], rdx
        mov	qword ptr [rdi + 272], rax
.LBB3_4:
        mov	rsi, rsp
        mov	rdx, rdi
        call	".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish"
        add	rsp, 24
        ret

