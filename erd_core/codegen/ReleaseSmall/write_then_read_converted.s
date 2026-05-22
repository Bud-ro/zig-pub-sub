; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal (until 2 calls)
; NOINLINE-PUB. PER-ERD write + converted read inlined.
;
write_then_read_converted:
        push	rbx
        mov	rbx, rdi
        call	".Lsystem_data.SystemData(codegen_harness.MultiErdDefs,meta.FieldEnum(codegen_harness.MultiErdDefs),.{ .ram_counter = .{ ... }, .ram_flag = .{ ... }, .ram_value = .{ ... }, .ind_constant = .{ ... }, .ind_computed = .{ ... }, .conv_sum = .{ ... }, .conv_flag_inv = .{ ... } },codegen_harness.MultiComponents).write__anon_0"
        mov	rcx, qword ptr [rbx + 168]
        movzx	eax, word ptr [rcx + 5]
        add	eax, dword ptr [rcx]
        pop	rbx
        ret

; --- called functions ---

".Lsystem_data.SystemData(codegen_harness.MultiErdDefs,meta.FieldEnum(codegen_harness.MultiErdDefs),.{ .ram_counter = .{ ... }, .ram_flag = .{ ... }, .ram_value = .{ ... }, .ind_constant = .{ ... }, .ind_computed = .{ ... }, .conv_sum = .{ ... }, .conv_flag_inv = .{ ... } },codegen_harness.MultiComponents).write__anon_0":
        push	rax
        mov	dword ptr [rsp + 4], esi
        cmp	dword ptr [rdi], esi
        mov	dword ptr [rdi], esi
        je	.L1
        lea	rdx, [rsp + 4]
        xor	esi, esi
        mov	rcx, rdi
        call	".Lram_data_component.RamDataComponent(@as([*]const Erd, @ptrCast(&codegen_harness.ram_defs))[0..3]).publish"
.L1:
        pop	rax
        ret

