write_medium_with_subs:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 32
        mov	rcx, qword ptr [rsi + 16]
        lea	rax, [rbp - 32]
        mov	qword ptr [rax + 16], rcx
        movups	xmm0, xmmword ptr [rsi]
        movaps	xmmword ptr [rax], xmm0
        mov	rsi, rax
        call	".Lsystem_data.SystemData(codegen_harness.HugeSystem__struct_0,meta.FieldEnum(codegen_harness.HugeSystem__struct_0),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },system_data_test_double.create.Components).write__anon_1"
        add	rsp, 32
        pop	rbp
        ret

; --- called functions ---

".Lsystem_data.SystemData(codegen_harness.HugeSystem__struct_0,meta.FieldEnum(codegen_harness.HugeSystem__struct_0),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },system_data_test_double.create.Components).write__anon_1":
        push	rbp
        mov	rbp, rsp
        sub	rsp, 32
        mov	rax, qword ptr [rsi + 16]
        mov	qword ptr [rbp - 16], rax
        movups	xmm0, xmmword ptr [rsi]
        movaps	xmmword ptr [rbp - 32], xmm0
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
        add	rsp, 32
        pop	rbp
        ret
.LBB3_2:
        mov	qword ptr [rdi + 256], rcx
        mov	qword ptr [rdi + 264], rdx
        mov	qword ptr [rdi + 272], rax
.LBB3_4:
        lea	rsi, [rbp - 32]
        mov	rdx, rdi
        call	".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish"
        add	rsp, 32
        pop	rbp
        ret

