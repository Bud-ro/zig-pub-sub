; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal
; Size-comparison counterpart to wide_write_all: writes every ERD
; via the shared runtimeWrite dispatch (see wide_runtime_write for
; the publish-chain cost) instead of inlining a PER-ERD store per
; field. ReleaseFast unrolls the loop into 16 explicit calls (264
; bytes); ReleaseSmall keeps the loop (40 bytes). Slower than
; wide_write_all (per-call table lookups + memcpy + bytesEqual) but
; a fraction of the ROM.
;
wide_runtime_write_all:
        push	r14
        push	rbx
        push	rax
        mov	rbx, rsi
        mov	r14, rdi
        xor	esi, esi
        mov	rdx, rbx
        call	"system_data.SystemData(codegen_mono_stress.WideSystem__struct_0,meta.FieldEnum(codegen_mono_stress.WideSystem__struct_0),.{ .w00 = .{ ... }, .w01 = .{ ... }, .w02 = .{ ... }, .w03 = .{ ... }, .w04 = .{ ... }, .w05 = .{ ... }, .w06 = .{ ... }, .w07 = .{ ... }, .w08 = .{ ... }, .w09 = .{ ... }, .w10 = .{ ... }, .w11 = .{ ... }, .w12 = .{ ... }, .w13 = .{ ... }, .w14 = .{ ... }, .w15 = .{ ... }, .w_pair = .{ ... } },system_data_test_double.create.Components).runtimeWrite"
        mov	rdi, r14
        mov	esi, 1
        mov	rdx, rbx
        call	"system_data.SystemData(codegen_mono_stress.WideSystem__struct_0,meta.FieldEnum(codegen_mono_stress.WideSystem__struct_0),.{ .w00 = .{ ... }, .w01 = .{ ... }, .w02 = .{ ... }, .w03 = .{ ... }, .w04 = .{ ... }, .w05 = .{ ... }, .w06 = .{ ... }, .w07 = .{ ... }, .w08 = .{ ... }, .w09 = .{ ... }, .w10 = .{ ... }, .w11 = .{ ... }, .w12 = .{ ... }, .w13 = .{ ... }, .w14 = .{ ... }, .w15 = .{ ... }, .w_pair = .{ ... } },system_data_test_double.create.Components).runtimeWrite"
        mov	rdi, r14
        mov	esi, 2
        mov	rdx, rbx
        call	"system_data.SystemData(codegen_mono_stress.WideSystem__struct_0,meta.FieldEnum(codegen_mono_stress.WideSystem__struct_0),.{ .w00 = .{ ... }, .w01 = .{ ... }, .w02 = .{ ... }, .w03 = .{ ... }, .w04 = .{ ... }, .w05 = .{ ... }, .w06 = .{ ... }, .w07 = .{ ... }, .w08 = .{ ... }, .w09 = .{ ... }, .w10 = .{ ... }, .w11 = .{ ... }, .w12 = .{ ... }, .w13 = .{ ... }, .w14 = .{ ... }, .w15 = .{ ... }, .w_pair = .{ ... } },system_data_test_double.create.Components).runtimeWrite"
        mov	rdi, r14
        mov	esi, 3
        mov	rdx, rbx
        call	"system_data.SystemData(codegen_mono_stress.WideSystem__struct_0,meta.FieldEnum(codegen_mono_stress.WideSystem__struct_0),.{ .w00 = .{ ... }, .w01 = .{ ... }, .w02 = .{ ... }, .w03 = .{ ... }, .w04 = .{ ... }, .w05 = .{ ... }, .w06 = .{ ... }, .w07 = .{ ... }, .w08 = .{ ... }, .w09 = .{ ... }, .w10 = .{ ... }, .w11 = .{ ... }, .w12 = .{ ... }, .w13 = .{ ... }, .w14 = .{ ... }, .w15 = .{ ... }, .w_pair = .{ ... } },system_data_test_double.create.Components).runtimeWrite"
        mov	rdi, r14
        mov	esi, 4
        mov	rdx, rbx
        call	"system_data.SystemData(codegen_mono_stress.WideSystem__struct_0,meta.FieldEnum(codegen_mono_stress.WideSystem__struct_0),.{ .w00 = .{ ... }, .w01 = .{ ... }, .w02 = .{ ... }, .w03 = .{ ... }, .w04 = .{ ... }, .w05 = .{ ... }, .w06 = .{ ... }, .w07 = .{ ... }, .w08 = .{ ... }, .w09 = .{ ... }, .w10 = .{ ... }, .w11 = .{ ... }, .w12 = .{ ... }, .w13 = .{ ... }, .w14 = .{ ... }, .w15 = .{ ... }, .w_pair = .{ ... } },system_data_test_double.create.Components).runtimeWrite"
        mov	rdi, r14
        mov	esi, 5
        mov	rdx, rbx
        call	"system_data.SystemData(codegen_mono_stress.WideSystem__struct_0,meta.FieldEnum(codegen_mono_stress.WideSystem__struct_0),.{ .w00 = .{ ... }, .w01 = .{ ... }, .w02 = .{ ... }, .w03 = .{ ... }, .w04 = .{ ... }, .w05 = .{ ... }, .w06 = .{ ... }, .w07 = .{ ... }, .w08 = .{ ... }, .w09 = .{ ... }, .w10 = .{ ... }, .w11 = .{ ... }, .w12 = .{ ... }, .w13 = .{ ... }, .w14 = .{ ... }, .w15 = .{ ... }, .w_pair = .{ ... } },system_data_test_double.create.Components).runtimeWrite"
        mov	rdi, r14
        mov	esi, 6
        mov	rdx, rbx
        call	"system_data.SystemData(codegen_mono_stress.WideSystem__struct_0,meta.FieldEnum(codegen_mono_stress.WideSystem__struct_0),.{ .w00 = .{ ... }, .w01 = .{ ... }, .w02 = .{ ... }, .w03 = .{ ... }, .w04 = .{ ... }, .w05 = .{ ... }, .w06 = .{ ... }, .w07 = .{ ... }, .w08 = .{ ... }, .w09 = .{ ... }, .w10 = .{ ... }, .w11 = .{ ... }, .w12 = .{ ... }, .w13 = .{ ... }, .w14 = .{ ... }, .w15 = .{ ... }, .w_pair = .{ ... } },system_data_test_double.create.Components).runtimeWrite"
        mov	rdi, r14
        mov	esi, 7
        mov	rdx, rbx
        call	"system_data.SystemData(codegen_mono_stress.WideSystem__struct_0,meta.FieldEnum(codegen_mono_stress.WideSystem__struct_0),.{ .w00 = .{ ... }, .w01 = .{ ... }, .w02 = .{ ... }, .w03 = .{ ... }, .w04 = .{ ... }, .w05 = .{ ... }, .w06 = .{ ... }, .w07 = .{ ... }, .w08 = .{ ... }, .w09 = .{ ... }, .w10 = .{ ... }, .w11 = .{ ... }, .w12 = .{ ... }, .w13 = .{ ... }, .w14 = .{ ... }, .w15 = .{ ... }, .w_pair = .{ ... } },system_data_test_double.create.Components).runtimeWrite"
        mov	rdi, r14
        mov	esi, 8
        mov	rdx, rbx
        call	"system_data.SystemData(codegen_mono_stress.WideSystem__struct_0,meta.FieldEnum(codegen_mono_stress.WideSystem__struct_0),.{ .w00 = .{ ... }, .w01 = .{ ... }, .w02 = .{ ... }, .w03 = .{ ... }, .w04 = .{ ... }, .w05 = .{ ... }, .w06 = .{ ... }, .w07 = .{ ... }, .w08 = .{ ... }, .w09 = .{ ... }, .w10 = .{ ... }, .w11 = .{ ... }, .w12 = .{ ... }, .w13 = .{ ... }, .w14 = .{ ... }, .w15 = .{ ... }, .w_pair = .{ ... } },system_data_test_double.create.Components).runtimeWrite"
        mov	rdi, r14
        mov	esi, 9
        mov	rdx, rbx
        call	"system_data.SystemData(codegen_mono_stress.WideSystem__struct_0,meta.FieldEnum(codegen_mono_stress.WideSystem__struct_0),.{ .w00 = .{ ... }, .w01 = .{ ... }, .w02 = .{ ... }, .w03 = .{ ... }, .w04 = .{ ... }, .w05 = .{ ... }, .w06 = .{ ... }, .w07 = .{ ... }, .w08 = .{ ... }, .w09 = .{ ... }, .w10 = .{ ... }, .w11 = .{ ... }, .w12 = .{ ... }, .w13 = .{ ... }, .w14 = .{ ... }, .w15 = .{ ... }, .w_pair = .{ ... } },system_data_test_double.create.Components).runtimeWrite"
        mov	rdi, r14
        mov	esi, 10
        mov	rdx, rbx
        call	"system_data.SystemData(codegen_mono_stress.WideSystem__struct_0,meta.FieldEnum(codegen_mono_stress.WideSystem__struct_0),.{ .w00 = .{ ... }, .w01 = .{ ... }, .w02 = .{ ... }, .w03 = .{ ... }, .w04 = .{ ... }, .w05 = .{ ... }, .w06 = .{ ... }, .w07 = .{ ... }, .w08 = .{ ... }, .w09 = .{ ... }, .w10 = .{ ... }, .w11 = .{ ... }, .w12 = .{ ... }, .w13 = .{ ... }, .w14 = .{ ... }, .w15 = .{ ... }, .w_pair = .{ ... } },system_data_test_double.create.Components).runtimeWrite"
        mov	rdi, r14
        mov	esi, 11
        mov	rdx, rbx
        call	"system_data.SystemData(codegen_mono_stress.WideSystem__struct_0,meta.FieldEnum(codegen_mono_stress.WideSystem__struct_0),.{ .w00 = .{ ... }, .w01 = .{ ... }, .w02 = .{ ... }, .w03 = .{ ... }, .w04 = .{ ... }, .w05 = .{ ... }, .w06 = .{ ... }, .w07 = .{ ... }, .w08 = .{ ... }, .w09 = .{ ... }, .w10 = .{ ... }, .w11 = .{ ... }, .w12 = .{ ... }, .w13 = .{ ... }, .w14 = .{ ... }, .w15 = .{ ... }, .w_pair = .{ ... } },system_data_test_double.create.Components).runtimeWrite"
        mov	rdi, r14
        mov	esi, 12
        mov	rdx, rbx
        call	"system_data.SystemData(codegen_mono_stress.WideSystem__struct_0,meta.FieldEnum(codegen_mono_stress.WideSystem__struct_0),.{ .w00 = .{ ... }, .w01 = .{ ... }, .w02 = .{ ... }, .w03 = .{ ... }, .w04 = .{ ... }, .w05 = .{ ... }, .w06 = .{ ... }, .w07 = .{ ... }, .w08 = .{ ... }, .w09 = .{ ... }, .w10 = .{ ... }, .w11 = .{ ... }, .w12 = .{ ... }, .w13 = .{ ... }, .w14 = .{ ... }, .w15 = .{ ... }, .w_pair = .{ ... } },system_data_test_double.create.Components).runtimeWrite"
        mov	rdi, r14
        mov	esi, 13
        mov	rdx, rbx
        call	"system_data.SystemData(codegen_mono_stress.WideSystem__struct_0,meta.FieldEnum(codegen_mono_stress.WideSystem__struct_0),.{ .w00 = .{ ... }, .w01 = .{ ... }, .w02 = .{ ... }, .w03 = .{ ... }, .w04 = .{ ... }, .w05 = .{ ... }, .w06 = .{ ... }, .w07 = .{ ... }, .w08 = .{ ... }, .w09 = .{ ... }, .w10 = .{ ... }, .w11 = .{ ... }, .w12 = .{ ... }, .w13 = .{ ... }, .w14 = .{ ... }, .w15 = .{ ... }, .w_pair = .{ ... } },system_data_test_double.create.Components).runtimeWrite"
        mov	rdi, r14
        mov	esi, 14
        mov	rdx, rbx
        call	"system_data.SystemData(codegen_mono_stress.WideSystem__struct_0,meta.FieldEnum(codegen_mono_stress.WideSystem__struct_0),.{ .w00 = .{ ... }, .w01 = .{ ... }, .w02 = .{ ... }, .w03 = .{ ... }, .w04 = .{ ... }, .w05 = .{ ... }, .w06 = .{ ... }, .w07 = .{ ... }, .w08 = .{ ... }, .w09 = .{ ... }, .w10 = .{ ... }, .w11 = .{ ... }, .w12 = .{ ... }, .w13 = .{ ... }, .w14 = .{ ... }, .w15 = .{ ... }, .w_pair = .{ ... } },system_data_test_double.create.Components).runtimeWrite"
        mov	rdi, r14
        mov	esi, 15
        mov	rdx, rbx
        add	rsp, 8
        pop	rbx
        pop	r14
        jmp	"system_data.SystemData(codegen_mono_stress.WideSystem__struct_0,meta.FieldEnum(codegen_mono_stress.WideSystem__struct_0),.{ .w00 = .{ ... }, .w01 = .{ ... }, .w02 = .{ ... }, .w03 = .{ ... }, .w04 = .{ ... }, .w05 = .{ ... }, .w06 = .{ ... }, .w07 = .{ ... }, .w08 = .{ ... }, .w09 = .{ ... }, .w10 = .{ ... }, .w11 = .{ ... }, .w12 = .{ ... }, .w13 = .{ ... }, .w14 = .{ ... }, .w15 = .{ ... }, .w_pair = .{ ... } },system_data_test_double.create.Components).runtimeWrite"

; --- called functions ---

"system_data.SystemData(codegen_mono_stress.WideSystem__struct_0,meta.FieldEnum(codegen_mono_stress.WideSystem__struct_0),.{ .w00 = .{ ... }, .w01 = .{ ... }, .w02 = .{ ... }, .w03 = .{ ... }, .w04 = .{ ... }, .w05 = .{ ... }, .w06 = .{ ... }, .w07 = .{ ... }, .w08 = .{ ... }, .w09 = .{ ... }, .w10 = .{ ... }, .w11 = .{ ... }, .w12 = .{ ... }, .w13 = .{ ... }, .w14 = .{ ... }, .w15 = .{ ... }, .w_pair = .{ ... } },system_data_test_double.create.Components).runtimeWrite":
        push	rbp
        push	r15
        push	r14
        push	r13
        push	r12
        push	rbx
        push	rax
        mov	rbx, rdx
        mov	r14, rdi
        movzx	eax, si
        movzx	r15d, word ptr [rax + rax + __anon_1]
        movzx	r12d, word ptr [r15 + r15 + __anon_2]
        mov	r13, qword ptr [8*r15 + __anon_3]
        add	r13, rdi
        mov	rdi, rdx
        mov	rsi, r13
        mov	rdx, r12
        call	ram_data_component.runtimeBytesEqual
        mov	ebp, eax
        mov	rdi, r13
        mov	rsi, rbx
        mov	rdx, r12
        call	memcpy@PLT
        test	bpl, 1
        jne	.L4
        cmp	byte ptr [r15 + __anon_5], 0
        je	.L4
        mov	rdi, r14
        mov	esi, r15d
        mov	rdx, rbx
        mov	rcx, r14
        add	rsp, 8
        pop	rbx
        pop	r12
        pop	r13
        pop	r14
        pop	r15
        pop	rbp
        jmp	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).publish"
.L4:
        add	rsp, 8
        pop	rbx
        pop	r12
        pop	r13
        pop	r14
        pop	r15
        pop	rbp
        ret

