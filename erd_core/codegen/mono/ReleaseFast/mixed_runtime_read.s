; snapshot_comments.zig
; Speed: Optimal | Size: Optimal
;
mixed_runtime_read:
        jmp	"system_data.SystemData(codegen_mono_stress.MixedDefs,meta.FieldEnum(codegen_mono_stress.MixedDefs),.{ .ram_a = .{ ... }, .ram_b = .{ ... }, .ram_c = .{ ... }, .ram_d = .{ ... }, .ind_x = .{ ... }, .ind_y = .{ ... }, .conv_sum = .{ ... }, .conv_flag = .{ ... }, .conv_wide = .{ ... }, .ram_pair = .{ ... } },codegen_mono_stress.MixedComponents).runtimeRead"

; --- called functions ---

"system_data.SystemData(codegen_mono_stress.MixedDefs,meta.FieldEnum(codegen_mono_stress.MixedDefs),.{ .ram_a = .{ ... }, .ram_b = .{ ... }, .ram_c = .{ ... }, .ram_d = .{ ... }, .ind_x = .{ ... }, .ind_y = .{ ... }, .conv_sum = .{ ... }, .conv_flag = .{ ... }, .conv_wide = .{ ... }, .ram_pair = .{ ... } },codegen_mono_stress.MixedComponents).runtimeRead":
        mov	rax, rdx
        movzx	ecx, si
        movzx	edx, byte ptr [rcx + __anon_0]
        movzx	ecx, word ptr [rcx + rcx + __anon_1]
        cmp	edx, 2
        je	.L0
        cmp	edx, 1
        jne	.L1
        mov	rdi, rax
        jmp	qword ptr [8*rcx + __anon_2]
.L0:
        mov	rsi, qword ptr [rdi + 168]
        mov	rdi, rax
        jmp	qword ptr [8*rcx + __anon_3]
.L1:
        add	rdi, qword ptr [8*rcx + __anon_4]
        movzx	edx, word ptr [rcx + rcx + __anon_5]
        mov	rsi, rdi
        mov	rdi, rax
        jmp	memcpy@PLT

