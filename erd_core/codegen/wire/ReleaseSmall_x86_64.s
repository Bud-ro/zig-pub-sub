wire_write_converted_dep:
        push	rax
        mov	dword ptr [rsp + 4], esi
        cmp	dword ptr [rdi + 35], esi
        mov	dword ptr [rdi + 35], esi
        je	.LBB0_2
        push	7
        pop	rsi
        lea	rdx, [rsp + 4]
        mov	rcx, rdi
        call	".Lram_data_component.RamDataComponent(@as([*]const Erd, @ptrCast(&codegen_wire_publisher.wire_ram_erds))[0..9]).publish"
.LBB0_2:
        pop	rax
        ret

wire_write_ram:
        push	rax
        mov	word ptr [rsp + 6], si
        cmp	word ptr [rdi], si
        mov	word ptr [rdi], si
        je	.LBB3_2
        lea	rdx, [rsp + 6]
        xor	esi, esi
        mov	rcx, rdi
        call	".Lram_data_component.RamDataComponent(@as([*]const Erd, @ptrCast(&codegen_wire_publisher.wire_ram_erds))[0..9]).publish"
.LBB3_2:
        pop	rax
        ret

wire_swap_reading:
        push	8
        pop	rsi
        jmp	".Lerd_swap.SwapRules(codegen_wire_publisher.Reading).applyToBig"

wire_swap_bytes4:
        ret

wire_swap_sample:
        mov	eax, dword ptr [rdi]
        bswap	eax
        mov	dword ptr [rdi], eax
        rol	word ptr [rdi + 4], 8
        ret

wire_swap_u64:
        mov	rax, qword ptr [rdi]
        bswap	rax
        mov	qword ptr [rdi], rax
        ret

wire_swap_u32:
        mov	eax, dword ptr [rdi]
        bswap	eax
        mov	dword ptr [rdi], eax
        ret

wire_swap_u16:
        rol	word ptr [rdi], 8
        ret

wire_pair_handler:
        jmp	".Lwire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{ .{ ... }, .{ ... } }[0..2],2).handler"

wire_single_handler:
        jmp	".Lwire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{.{ ... }}[0..1],1).handler"

wire_wide_handler:
        jmp	".Lwire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..8],3).handler"

wire_pair_post_init:
        push	r14
        push	rbx
        push	rax
        mov	rbx, rsi
        mov	r14, rdi
        mov	edx, offset ".Lwire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{ .{ ... }, .{ ... } }[0..2],2).handler"
        mov	rdi, rsi
        mov	rsi, r14
        call	".Lsystem_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents).subscribe__anon_0"
        mov	edx, offset ".Lwire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{ .{ ... }, .{ ... } }[0..2],2).handler"
        mov	rdi, rbx
        mov	rsi, r14
        add	rsp, 8
        pop	rbx
        pop	r14
        jmp	".Lsystem_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents).subscribe__anon_1"

wire_single_post_init:
        mov	rax, rdi
        mov	edx, offset ".Lwire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{.{ ... }}[0..1],1).handler"
        mov	rdi, rsi
        mov	rsi, rax
        jmp	".Lsystem_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents).subscribe__anon_2"

wire_wide_unsubscribe:
        jmp	.LSubscription.unsubscribe

wire_wide_subscribe:
        push	3
        pop	rsi
        mov	ecx, offset .Lcodegen_wire_publisher.downstreamCb
        xor	edx, edx
        jmp	.LSubscription.subscribe

wire_wide_post_init:
        push	r15
        push	r14
        push	rbx
        mov	r14, rsi
        mov	rbx, rdi
        mov	edx, offset ".Lwire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..8],3).handler"
        mov	rdi, rsi
        mov	rsi, rbx
        call	".Lsystem_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents).subscribe__anon_2"
        mov	edx, offset ".Lwire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..8],3).handler"
        mov	rdi, r14
        mov	rsi, rbx
        call	".Lsystem_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents).subscribe__anon_1"
        lea	r15, [r14 + 48]
        push	2
        pop	rsi
        mov	ecx, offset ".Lwire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..8],3).handler"
        mov	rdi, r15
        mov	rdx, rbx
        call	".Ldata_component_subscription.DataComponentSubscription(@as([*]const Erd, @ptrCast(&codegen_wire_publisher.wire_ram_erds))[0..9]).subscribeInner"
        mov	edx, offset ".Lwire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..8],3).handler"
        mov	rdi, r14
        mov	rsi, rbx
        call	".Lsystem_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents).subscribe__anon_0"
        push	4
        pop	rsi
        mov	ecx, offset ".Lwire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..8],3).handler"
        mov	rdi, r15
        mov	rdx, rbx
        call	".Ldata_component_subscription.DataComponentSubscription(@as([*]const Erd, @ptrCast(&codegen_wire_publisher.wire_ram_erds))[0..9]).subscribeInner"
        push	5
        pop	rsi
        mov	ecx, offset ".Lwire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..8],3).handler"
        mov	rdi, r15
        mov	rdx, rbx
        call	".Ldata_component_subscription.DataComponentSubscription(@as([*]const Erd, @ptrCast(&codegen_wire_publisher.wire_ram_erds))[0..9]).subscribeInner"
        push	6
        pop	rsi
        mov	ecx, offset ".Lwire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..8],3).handler"
        mov	rdi, r15
        mov	rdx, rbx
        call	".Ldata_component_subscription.DataComponentSubscription(@as([*]const Erd, @ptrCast(&codegen_wire_publisher.wire_ram_erds))[0..9]).subscribeInner"
        add	r14, 176
        mov	rdi, r14
        mov	rsi, rbx
        pop	rbx
        pop	r14
        pop	r15
        jmp	".Ldata_component_subscription.DataComponentSubscription(@as([*]const Erd, @ptrCast(&codegen_wire_publisher.wire_conv_erds))[0..1]).subscribeInner"

wire_wide_init:
        xorps	xmm0, xmm0
        movups	xmmword ptr [rdi + 32], xmm0
        movups	xmmword ptr [rdi + 16], xmm0
        movups	xmmword ptr [rdi], xmm0
        ret

; --- called functions ---

".Lram_data_component.RamDataComponent(@as([*]const Erd, @ptrCast(&codegen_wire_publisher.wire_ram_erds))[0..9]).publish":
        mov	r8, rcx
        mov	rcx, rdx
        movzx	eax, si
        mov	rdx, qword ptr [8*rax + .L__anon_3]
        movzx	esi, byte ptr [rax + .L__anon_4]
        shl	rdx, 4
        add	rdi, rdx
        add	rdi, 48
        movzx	edx, word ptr [rax + rax + .L__anon_5]
        jmp	.Lsystem_data.publishOnChange

".Lerd_swap.SwapRules(codegen_wire_publisher.Reading).applyToBig":
        push	r14
        push	rbx
        push	rax
        mov	r14, rsi
        mov	rbx, rdi
        mov	edi, offset .L__anon_6
        mov	esi, 3
        mov	edx, offset .L__anon_6
        mov	ecx, 3
        call	.Lmem.eql__anon_7
        test	r14, r14
        setne	cl
        and	cl, al
        cmp	cl, 1
        jne	.LBB5_7
        movzx	eax, byte ptr [rbx]
        cmp	eax, 1
        je	.LBB5_5
        test	eax, eax
        jne	.LBB5_7
        cmp	r14, 8
        jb	.LBB5_7
        mov	eax, dword ptr [rbx + 4]
        bswap	eax
        mov	dword ptr [rbx + 4], eax
.LBB5_7:
        add	rsp, 8
        pop	rbx
        pop	r14
        ret
.LBB5_5:
        cmp	r14, 6
        jb	.LBB5_7
        rol	word ptr [rbx + 4], 8
        add	rsp, 8
        pop	rbx
        pop	r14
        ret

".Lwire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{ .{ ... }, .{ ... } }[0..2],2).handler":
        push	r15
        push	r14
        push	r12
        push	rbx
        push	rax
        mov	rbx, rdx
        movzx	eax, word ptr [rsi + 8]
        mov	ecx, 2
        xor	edx, edx
        mov	r8, rcx
        sub	r8, rdx
        ja	.LBB17_2
        jmp	.LBB17_8
.LBB17_5:
        mov	rcx, r8
        mov	r8, rcx
        sub	r8, rdx
        jbe	.LBB17_8
.LBB17_2:
        shr	r8
        add	r8, rdx
        mov	r9, r8
        shl	r9, 4
        movzx	r10d, word ptr [r9 + ".Lwire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{ .{ ... }, .{ ... } }[0..2],2).descriptors"+8]
        cmp	r10w, ax
        je	.LBB17_6
        jae	.LBB17_5
        add	r8, 1
        mov	rdx, r8
        mov	r8, rcx
        sub	r8, rdx
        ja	.LBB17_2
        jmp	.LBB17_8
.LBB17_6:
        mov	r15, rdi
        lea	r12, [r9 + ".Lwire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{ .{ ... }, .{ ... } }[0..2],2).descriptors"]
        mov	rsi, qword ptr [rsi]
        movzx	r14d, word ptr [r12 + 12]
        lea	rdi, [rsp + 4]
        mov	rdx, r14
        call	memcpy@PLT
        mov	rax, qword ptr [r12]
        test	rax, rax
        je	.LBB17_7
        lea	rdi, [rsp + 4]
        mov	rsi, r14
        call	rax
.LBB17_7:
        movzx	esi, word ptr [r12 + 10]
        lea	rdx, [rsp + 4]
        mov	rdi, r15
        mov	rcx, r14
        mov	r8, rbx
        call	".Lwire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{ .{ ... }, .{ ... } }[0..2],2).publishWire"
.LBB17_8:
        add	rsp, 8
        pop	rbx
        pop	r12
        pop	r14
        pop	r15
        ret

".Lwire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{.{ ... }}[0..1],1).handler":
        cmp	word ptr [rsi + 8], 0
        je	.LBB20_1
        ret
.LBB20_1:
        push	rax
        mov	rax, qword ptr [rsi]
        movzx	eax, word ptr [rax]
        rol	ax, 8
        mov	word ptr [rsp + 6], ax
        lea	rsi, [rsp + 6]
        call	".Lwire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{.{ ... }}[0..1],1).publishWire"
        add	rsp, 8
        ret

".Lwire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..8],3).handler":
        push	r15
        push	r14
        push	r12
        push	rbx
        push	rax
        mov	rbx, rdx
        movzx	eax, word ptr [rsi + 8]
        mov	ecx, 8
        xor	edx, edx
        mov	r8, rcx
        sub	r8, rdx
        ja	.LBB23_2
        jmp	.LBB23_8
.LBB23_5:
        mov	rcx, r8
        mov	r8, rcx
        sub	r8, rdx
        jbe	.LBB23_8
.LBB23_2:
        shr	r8
        add	r8, rdx
        mov	r9, r8
        shl	r9, 4
        movzx	r10d, word ptr [r9 + ".Lwire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..8],3).descriptors"+8]
        cmp	r10w, ax
        je	.LBB23_6
        jae	.LBB23_5
        add	r8, 1
        mov	rdx, r8
        mov	r8, rcx
        sub	r8, rdx
        ja	.LBB23_2
        jmp	.LBB23_8
.LBB23_6:
        mov	r15, rdi
        lea	r12, [r9 + ".Lwire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..8],3).descriptors"]
        mov	rsi, qword ptr [rsi]
        movzx	r14d, word ptr [r12 + 12]
        mov	rdi, rsp
        mov	rdx, r14
        call	memcpy@PLT
        mov	rax, qword ptr [r12]
        test	rax, rax
        je	.LBB23_7
        mov	rdi, rsp
        mov	rsi, r14
        call	rax
.LBB23_7:
        movzx	esi, word ptr [r12 + 10]
        mov	rdx, rsp
        mov	rdi, r15
        mov	rcx, r14
        mov	r8, rbx
        call	".Lwire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..8],3).publishWire"
.LBB23_8:
        add	rsp, 8
        pop	rbx
        pop	r12
        pop	r14
        pop	r15
        ret

".Lsystem_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents).subscribe__anon_0":
        mov	rcx, rdx
        mov	rdx, rsi
        add	rdi, 48
        mov	esi, 3
        jmp	".Ldata_component_subscription.DataComponentSubscription(@as([*]const Erd, @ptrCast(&codegen_wire_publisher.wire_ram_erds))[0..9]).subscribeInner"

".Lsystem_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents).subscribe__anon_1":
        mov	rcx, rdx
        mov	rdx, rsi
        add	rdi, 48
        mov	esi, 1
        jmp	".Ldata_component_subscription.DataComponentSubscription(@as([*]const Erd, @ptrCast(&codegen_wire_publisher.wire_ram_erds))[0..9]).subscribeInner"

".Lsystem_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents).subscribe__anon_2":
        mov	rcx, rdx
        mov	rdx, rsi
        add	rdi, 48
        xor	esi, esi
        jmp	".Ldata_component_subscription.DataComponentSubscription(@as([*]const Erd, @ptrCast(&codegen_wire_publisher.wire_ram_erds))[0..9]).subscribeInner"

.LSubscription.unsubscribe:
        cmp	qword ptr [rdi + 8], offset .Lcodegen_wire_publisher.downstreamCb
        je	.LBB295_1
        cmp	qword ptr [rdi + 24], offset .Lcodegen_wire_publisher.downstreamCb
        je	.LBB295_3
        cmp	qword ptr [rdi + 40], offset .Lcodegen_wire_publisher.downstreamCb
        je	.LBB295_5
        ret
.LBB295_1:
        add	rdi, 8
        mov	qword ptr [rdi], 0
        ret
.LBB295_3:
        add	rdi, 24
        mov	qword ptr [rdi], 0
        ret
.LBB295_5:
        add	rdi, 40
        mov	qword ptr [rdi], 0
        ret

.LSubscription.subscribe:
        mov	r8, qword ptr [rdi + 8]
        cmp	r8, rcx
        je	.LBB29_8
        xor	eax, eax
        test	r8, r8
        cmove	rax, rdi
        cmp	rsi, 1
        je	.LBB29_6
        lea	r9, [rdi + 16]
        mov	r10, qword ptr [rdi + 24]
        xor	eax, eax
        test	r10, r10
        cmove	rax, r9
        test	r8, r8
        cmove	rax, rdi
        cmp	r10, rcx
        je	.LBB29_8
        cmp	rsi, 2
        je	.LBB29_6
        mov	rsi, qword ptr [rdi + 40]
        cmp	rsi, rcx
        je	.LBB29_8
        add	rdi, 32
        xor	r8d, r8d
        test	rsi, rsi
        cmove	r8, rdi
        test	rax, rax
        cmove	rax, r8
.LBB29_6:
        test	rax, rax
        je	.LBB29_9
        mov	qword ptr [rax], rdx
        mov	qword ptr [rax + 8], rcx
.LBB29_8:
        ret
.LBB29_9:
        push	rax
        mov	edi, offset .L__anon_8
        mov	esi, 19
        call	.Ldebug.defaultPanic

".Ldata_component_subscription.DataComponentSubscription(@as([*]const Erd, @ptrCast(&codegen_wire_publisher.wire_ram_erds))[0..9]).subscribeInner":
        shl	rsi, 4
        add	rdi, rsi
        mov	esi, 1
        jmp	.LSubscription.subscribe

".Ldata_component_subscription.DataComponentSubscription(@as([*]const Erd, @ptrCast(&codegen_wire_publisher.wire_conv_erds))[0..1]).subscribeInner":
        mov	rdx, rsi
        mov	esi, 1
        mov	ecx, offset ".Lwire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..8],3).handler"
        jmp	.LSubscription.subscribe

.Lsystem_data.publishOnChange:
        push	r15
        push	r14
        push	r13
        push	r12
        push	rbx
        sub	rsp, 16
        mov	rbx, r8
        mov	r14, rsi
        mov	r15, rdi
        mov	word ptr [rsp + 8], dx
        mov	qword ptr [rsp], rcx
        shl	r14, 4
        xor	r13d, r13d
        mov	r12, rsp
        cmp	r14, r13
        jne	.LBB2_2
        jmp	.LBB2_4
.LBB2_3:
        add	r13, 16
        cmp	r14, r13
        je	.LBB2_4
.LBB2_2:
        mov	rax, qword ptr [r15 + r13 + 8]
        test	rax, rax
        je	.LBB2_3
        mov	rdi, qword ptr [r15 + r13]
        mov	rsi, r12
        mov	rdx, rbx
        call	rax
        add	r13, 16
        cmp	r14, r13
        jne	.LBB2_2
.LBB2_4:
        add	rsp, 16
        pop	rbx
        pop	r12
        pop	r13
        pop	r14
        pop	r15
        ret

.Lmem.eql__anon_7:
        test	rsi, rsi
        movabs	rax, 1
        mov	r8, rdi
        cmove	r8, rax
        test	rcx, rcx
        cmove	rdx, rax
        cmp	rsi, rcx
        jne	.LBB6_8
        test	rsi, rsi
        sete	al
        cmp	r8, rdx
        sete	cl
        or	cl, al
        mov	al, 1
        jne	.LBB6_9
        cmp	rsi, 16
        ja	.LBB6_5
        cmp	rsi, 4
        jae	.LBB6_11
        mov	al, byte ptr [rdi]
        mov	cl, byte ptr [rdi + rsi - 1]
        mov	r8, rsi
        shr	r8
        xor	al, byte ptr [rdx]
        mov	dil, byte ptr [rdi + r8]
        xor	cl, byte ptr [rdx + rsi - 1]
        or	cl, al
        xor	dil, byte ptr [rdx + r8]
        or	dil, cl
        jmp	.LBB6_15
.LBB6_5:
        lea	rax, [rsi - 1]
        shr	rax, 4
        inc	rax
        xor	ecx, ecx
.LBB6_6:
        dec	rax
        je	.LBB6_10
        movdqu	xmm0, xmmword ptr [r8 + rcx]
        movdqu	xmm1, xmmword ptr [rdx + rcx]
        add	rcx, 16
        pcmpeqb	xmm1, xmm0
        pmovmskb	edi, xmm1
        xor	edi, 65535
        je	.LBB6_6
.LBB6_8:
        xor	eax, eax
.LBB6_9:
        ret
.LBB6_10:
        movdqu	xmm0, xmmword ptr [r8 + rsi - 16]
        movdqu	xmm1, xmmword ptr [rdx + rsi - 16]
        pcmpeqb	xmm1, xmm0
        pmovmskb	eax, xmm1
        xor	eax, 65535
        jmp	.LBB6_15
.LBB6_11:
        lea	rax, [rsi - 4]
        and	qword ptr [rsp - 32], 0
        shr	esi
        and	esi, 12
        mov	qword ptr [rsp - 24], rax
        sub	rax, rsi
        mov	qword ptr [rsp - 16], rsi
        mov	qword ptr [rsp - 8], rax
        xor	eax, eax
        xor	ecx, ecx
.LBB6_12:
        cmp	rcx, 4
        je	.LBB6_14
        mov	rsi, qword ptr [rsp + 8*rcx - 32]
        mov	edi, dword ptr [rdx + rsi]
        xor	edi, dword ptr [r8 + rsi]
        or	eax, edi
        inc	rcx
        jmp	.LBB6_12
.LBB6_14:
        test	eax, eax
.LBB6_15:
        sete	al
        ret

".Lwire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{ .{ ... }, .{ ... } }[0..2],2).publishWire":
        push	r14
        push	rbx
        sub	rsp, 24
        mov	rbx, r8
        mov	r14, rdi
        mov	word ptr [rsp + 16], si
        mov	qword ptr [rsp], rdx
        mov	qword ptr [rsp + 8], rcx
        mov	rax, qword ptr [rdi + 8]
        test	rax, rax
        je	.LBB18_1
        mov	rdi, qword ptr [r14]
        mov	rsi, rsp
        mov	rdx, rbx
        call	rax
.LBB18_1:
        mov	rax, qword ptr [r14 + 24]
        test	rax, rax
        je	.LBB18_3
        mov	rdi, qword ptr [r14 + 16]
        mov	rsi, rsp
        mov	rdx, rbx
        call	rax
.LBB18_3:
        add	rsp, 24
        pop	rbx
        pop	r14
        ret

".Lwire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{.{ ... }}[0..1],1).publishWire":
        sub	rsp, 24
        mov	word ptr [rsp + 16], 4096
        mov	qword ptr [rsp], rsi
        mov	qword ptr [rsp + 8], 2
        mov	rax, qword ptr [rdi + 8]
        test	rax, rax
        je	.LBB21_2
        mov	rdi, qword ptr [rdi]
        mov	rsi, rsp
        call	rax
.LBB21_2:
        add	rsp, 24
        ret

".Lwire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..8],3).publishWire":
        push	r14
        push	rbx
        sub	rsp, 24
        mov	rbx, r8
        mov	r14, rdi
        mov	word ptr [rsp + 16], si
        mov	qword ptr [rsp], rdx
        mov	qword ptr [rsp + 8], rcx
        mov	rax, qword ptr [rdi + 8]
        test	rax, rax
        je	.LBB24_1
        mov	rdi, qword ptr [r14]
        mov	rsi, rsp
        mov	rdx, rbx
        call	rax
.LBB24_1:
        mov	rax, qword ptr [r14 + 24]
        test	rax, rax
        je	.LBB24_3
        mov	rdi, qword ptr [r14 + 16]
        mov	rsi, rsp
        mov	rdx, rbx
        call	rax
.LBB24_3:
        mov	rax, qword ptr [r14 + 40]
        test	rax, rax
        je	.LBB24_5
        mov	rdi, qword ptr [r14 + 32]
        mov	rsi, rsp
        mov	rdx, rbx
        call	rax
.LBB24_5:
        add	rsp, 24
        pop	rbx
        pop	r14
        ret

.Ldebug.defaultPanic:
        push	rbp
        push	r15
        push	r14
        push	r12
        push	rbx
        sub	rsp, 128
        mov	rax, qword ptr fs:[.Ldebug.panic_stage@TPOFF]
        test	rax, rax
        jne	.LBB30_16
        mov	rbx, rsi
        mov	r15, rdi
        mov	qword ptr fs:[.Ldebug.panic_stage@TPOFF], 1
        lock		inc	byte ptr [rip + .Ldebug.panicking]
        lea	r12, [rsp + 96]
        mov	rdi, r12
        call	.Ldebug.lockStderr
        mov	r14, qword ptr [r12]
        mov	al, byte ptr [r12 + 8]
        add	r14, 24
        mov	qword ptr [rsp + 8], r14
        and	al, 3
        mov	byte ptr [rsp + 16], al
        call	.LThread.getCurrentId
        mov	ebp, eax
        push	7
        pop	rdx
        mov	esi, offset .L__anon_9
        mov	rdi, r14
        call	.LIo.Writer.writeAll
        test	ax, ax
        jne	.LBB30_13
        mov	ecx, ebp
        push	63
        pop	rdi
        push	100
        pop	rsi
        mov	r8b, 10
.LBB30_3:
        cmp	rcx, 100
        jb	.LBB30_5
        mov	rax, rcx
        xor	edx, edx
        div	rsi
        movzx	edx, dl
        mov	rcx, rax
        mov	eax, edx
        div	r8b
        movzx	edx, ah
        or	dl, 48
        movzx	edx, dl
        shl	edx, 8
        movzx	eax, al
        add	eax, edx
        add	eax, 48
        mov	word ptr [rsp + rdi + 31], ax
        add	rdi, -2
        jmp	.LBB30_3
.LBB30_5:
        cmp	rcx, 9
        ja	.LBB30_7
        or	cl, 48
        mov	byte ptr [rsp + rdi + 32], cl
        inc	rdi
        jmp	.LBB30_8
.LBB30_7:
        movzx	eax, cl
        mov	cl, 10
        div	cl
        movzx	ecx, ah
        or	cl, 48
        movzx	ecx, cl
        shl	ecx, 8
        movzx	eax, al
        add	eax, ecx
        add	eax, 48
        mov	word ptr [rsp + rdi + 31], ax
.LBB30_8:
        lea	rsi, [rsp + rdi]
        add	rsi, 31
        push	65
        pop	rdx
        sub	rdx, rdi
        mov	rdi, r14
        call	.LIo.Writer.writeAll
        test	ax, ax
        jne	.LBB30_13
        push	8
        pop	rdx
        mov	esi, offset .L__anon_10
        mov	rdi, r14
        call	.LIo.Writer.writeAll
        test	ax, ax
        jne	.LBB30_13
        mov	rdi, r14
        mov	rsi, r15
        mov	rdx, rbx
        call	.LIo.Writer.writeAll
        test	ax, ax
        jne	.LBB30_13
        push	1
        pop	rdx
        mov	esi, offset .L__anon_11
        mov	rdi, r14
        call	.LIo.Writer.writeAll
        test	ax, ax
        jne	.LBB30_13
        lea	rdi, [rsp + 8]
        call	.Ldebug.writeCurrentStackTrace
.LBB30_13:
        mov	edi, offset .LIo.Threaded.global_single_threaded_instance
        call	.LIo.Threaded.unlockStderr
        lock		dec	byte ptr [rip + .Ldebug.panicking]
        je	.LBB30_18
        lea	rbx, [rsp + 31]
        and	dword ptr [rbx], 0
.LBB30_15:
        mov	edx, offset .L__anon_12
        mov	rdi, rbx
        xor	esi, esi
        call	.LIo.Threaded.Thread.futexWaitUncancelable
        jmp	.LBB30_15
.LBB30_16:
        cmp	rax, 1
        jne	.LBB30_18
        mov	qword ptr fs:[.Ldebug.panic_stage@TPOFF], 2
        lea	rbx, [rsp + 112]
        mov	rdi, rbx
        call	.Ldebug.lockStderr
        mov	rdi, qword ptr [rbx]
        add	rdi, 24
        push	32
        pop	rdx
        mov	esi, offset .L__anon_13
        call	.LIo.Writer.writeAll
.LBB30_18:
        call	.Lprocess.abort
        .text

