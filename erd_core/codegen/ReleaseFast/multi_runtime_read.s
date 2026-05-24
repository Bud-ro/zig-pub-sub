; snapshot_comments.zig
; Speed: Optimal | Size: Optimal
;
multi_runtime_read:
        jmp	"system_data.SystemData(codegen_harness.MultiErdDefs,meta.FieldEnum(codegen_harness.MultiErdDefs),.{ .ram_counter = .{ ... }, .ram_flag = .{ ... }, .ram_value = .{ ... }, .ind_constant = .{ ... }, .ind_computed = .{ ... }, .conv_sum = .{ ... }, .conv_flag_inv = .{ ... } },codegen_harness.MultiComponents).runtimeRead"

; --- called functions ---

"system_data.SystemData(codegen_harness.MultiErdDefs,meta.FieldEnum(codegen_harness.MultiErdDefs),.{ .ram_counter = .{ ... }, .ram_flag = .{ ... }, .ram_value = .{ ... }, .ind_constant = .{ ... }, .ind_computed = .{ ... }, .conv_sum = .{ ... }, .conv_flag_inv = .{ ... } },codegen_harness.MultiComponents).runtimeRead":
        mov	rax, rdx
        movzx	ecx, si
        movzx	edx, byte ptr [rcx + __anon_0]
        movzx	ecx, word ptr [rcx + rcx + __anon_1]
        cmp	edx, 2
        je	.L2
        cmp	edx, 1
        jne	.L3
        mov	rdi, rax
        jmp	qword ptr [8*rcx + __anon_4]
.L2:
        mov	rsi, qword ptr [rdi + 136]
        mov	rdi, rax
        jmp	qword ptr [8*rcx + __anon_5]
.L3:
        add	rdi, qword ptr [8*rcx + __anon_6]
        movzx	edx, word ptr [rcx + rcx + __anon_7]
        mov	rsi, rdi
        mov	rdi, rax
        jmp	memcpy@PLT

