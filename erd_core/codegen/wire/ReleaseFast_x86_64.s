wire_write_converted_dep:
        push	rax
        mov	dword ptr [rsp + 4], esi
        cmp	dword ptr [rdi + 35], esi
        mov	dword ptr [rdi + 35], esi
        je	.LBB0_2
        lea	rdx, [rsp + 4]
        mov	esi, 7
        mov	rcx, rdi
        call	"ram_data_component.RamDataComponent(@as([*]const Erd, @ptrCast(&codegen_wire_publisher.wire_ram_erds))[0..9]).publish"
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
        call	"ram_data_component.RamDataComponent(@as([*]const Erd, @ptrCast(&codegen_wire_publisher.wire_ram_erds))[0..9]).publish"
.LBB3_2:
        pop	rax
        ret

wire_swap_reading:
        movzx	eax, byte ptr [rdi]
        cmp	eax, 1
        je	.LBB4_3
        test	eax, eax
        jne	.LBB4_4
        mov	eax, dword ptr [rdi + 4]
        bswap	eax
        mov	dword ptr [rdi + 4], eax
        ret
.LBB4_3:
        rol	word ptr [rdi + 4], 8
.LBB4_4:
        ret

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
        push	r15
        push	r14
        push	r12
        push	rbx
        push	rax
        mov	rbx, rdx
        movzx	eax, word ptr [rsi + 8]
        mov	ecx, 2
        xor	edx, edx
        jmp	.LBB16_1
.LBB16_4:
        mov	rcx, r8
        cmp	rdx, rcx
        jae	.LBB16_8
.LBB16_1:
        mov	r8, rcx
        sub	r8, rdx
        shr	r8
        add	r8, rdx
        mov	r9, r8
        shl	r9, 4
        movzx	r10d, word ptr [r9 + "wire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{ .{ ... }, .{ ... } }[0..2],2).descriptors"+8]
        cmp	r10w, ax
        je	.LBB16_6
        jae	.LBB16_4
        add	r8, 1
        mov	rdx, r8
        cmp	rdx, rcx
        jb	.LBB16_1
        jmp	.LBB16_8
.LBB16_6:
        mov	r15, rdi
        lea	r12, [r9 + "wire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{ .{ ... }, .{ ... } }[0..2],2).descriptors"]
        mov	rsi, qword ptr [rsi]
        movzx	r14d, word ptr [r12 + 12]
        lea	rdi, [rsp + 4]
        mov	rdx, r14
        call	memcpy@PLT
        mov	rax, qword ptr [r12]
        test	rax, rax
        je	.LBB16_7
        lea	rdi, [rsp + 4]
        mov	rsi, r14
        call	rax
.LBB16_7:
        movzx	esi, word ptr [r12 + 10]
        lea	rdx, [rsp + 4]
        mov	rdi, r15
        mov	rcx, r14
        mov	r8, rbx
        call	"wire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{ .{ ... }, .{ ... } }[0..2],2).publishWire"
.LBB16_8:
        add	rsp, 8
        pop	rbx
        pop	r12
        pop	r14
        pop	r15
        ret

wire_single_handler:
        cmp	word ptr [rsi + 8], 0
        je	.LBB19_1
        ret
.LBB19_1:
        push	rax
        mov	rax, qword ptr [rsi]
        movzx	eax, word ptr [rax]
        rol	ax, 8
        mov	word ptr [rsp + 6], ax
        lea	rsi, [rsp + 6]
        call	"wire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{.{ ... }}[0..1],1).publishWire"
        add	rsp, 8
        ret

wire_wide_handler:
        push	r15
        push	r14
        push	r12
        push	rbx
        push	rax
        mov	rbx, rdx
        movzx	eax, word ptr [rsi + 8]
        mov	ecx, 8
        xor	edx, edx
        jmp	.LBB22_1
.LBB22_4:
        mov	rcx, r8
        cmp	rdx, rcx
        jae	.LBB22_8
.LBB22_1:
        mov	r8, rcx
        sub	r8, rdx
        shr	r8
        add	r8, rdx
        mov	r9, r8
        shl	r9, 4
        movzx	r10d, word ptr [r9 + "wire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..8],3).descriptors"+8]
        cmp	r10w, ax
        je	.LBB22_6
        jae	.LBB22_4
        add	r8, 1
        mov	rdx, r8
        cmp	rdx, rcx
        jb	.LBB22_1
        jmp	.LBB22_8
.LBB22_6:
        mov	r15, rdi
        lea	r12, [r9 + "wire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..8],3).descriptors"]
        mov	rsi, qword ptr [rsi]
        movzx	r14d, word ptr [r12 + 12]
        mov	rdi, rsp
        mov	rdx, r14
        call	memcpy@PLT
        mov	rax, qword ptr [r12]
        test	rax, rax
        je	.LBB22_7
        mov	rdi, rsp
        mov	rsi, r14
        call	rax
.LBB22_7:
        movzx	esi, word ptr [r12 + 10]
        mov	rdx, rsp
        mov	rdi, r15
        mov	rcx, r14
        mov	r8, rbx
        call	"wire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..8],3).publishWire"
.LBB22_8:
        add	rsp, 8
        pop	rbx
        pop	r12
        pop	r14
        pop	r15
        ret

wire_pair_post_init:
        push	r14
        push	rbx
        push	rax
        mov	rbx, rdi
        lea	r14, [rsi + 48]
        mov	esi, 3
        mov	ecx, offset "wire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{ .{ ... }, .{ ... } }[0..2],2).handler"
        mov	rdi, r14
        mov	rdx, rbx
        call	"data_component_subscription.DataComponentSubscription(@as([*]const Erd, @ptrCast(&codegen_wire_publisher.wire_ram_erds))[0..9]).subscribeInner"
        mov	esi, 1
        mov	ecx, offset "wire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{ .{ ... }, .{ ... } }[0..2],2).handler"
        mov	rdi, r14
        mov	rdx, rbx
        add	rsp, 8
        pop	rbx
        pop	r14
        jmp	"data_component_subscription.DataComponentSubscription(@as([*]const Erd, @ptrCast(&codegen_wire_publisher.wire_ram_erds))[0..9]).subscribeInner"

wire_single_post_init:
        mov	rdx, rdi
        lea	rdi, [rsi + 48]
        mov	ecx, offset "wire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{.{ ... }}[0..1],1).handler"
        xor	esi, esi
        jmp	"data_component_subscription.DataComponentSubscription(@as([*]const Erd, @ptrCast(&codegen_wire_publisher.wire_ram_erds))[0..9]).subscribeInner"

wire_wide_unsubscribe:
        jmp	Subscription.unsubscribe

wire_wide_subscribe:
        mov	esi, 3
        mov	ecx, offset codegen_wire_publisher.downstreamCb
        xor	edx, edx
        jmp	Subscription.subscribe

wire_wide_post_init:
        push	r15
        push	r14
        push	rbx
        mov	r14, rsi
        mov	rbx, rdi
        lea	r15, [rsi + 48]
        mov	ecx, offset "wire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..8],3).handler"
        mov	rdi, r15
        xor	esi, esi
        mov	rdx, rbx
        call	"data_component_subscription.DataComponentSubscription(@as([*]const Erd, @ptrCast(&codegen_wire_publisher.wire_ram_erds))[0..9]).subscribeInner"
        mov	esi, 1
        mov	ecx, offset "wire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..8],3).handler"
        mov	rdi, r15
        mov	rdx, rbx
        call	"data_component_subscription.DataComponentSubscription(@as([*]const Erd, @ptrCast(&codegen_wire_publisher.wire_ram_erds))[0..9]).subscribeInner"
        mov	esi, 2
        mov	ecx, offset "wire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..8],3).handler"
        mov	rdi, r15
        mov	rdx, rbx
        call	"data_component_subscription.DataComponentSubscription(@as([*]const Erd, @ptrCast(&codegen_wire_publisher.wire_ram_erds))[0..9]).subscribeInner"
        mov	esi, 3
        mov	ecx, offset "wire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..8],3).handler"
        mov	rdi, r15
        mov	rdx, rbx
        call	"data_component_subscription.DataComponentSubscription(@as([*]const Erd, @ptrCast(&codegen_wire_publisher.wire_ram_erds))[0..9]).subscribeInner"
        mov	esi, 4
        mov	ecx, offset "wire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..8],3).handler"
        mov	rdi, r15
        mov	rdx, rbx
        call	"data_component_subscription.DataComponentSubscription(@as([*]const Erd, @ptrCast(&codegen_wire_publisher.wire_ram_erds))[0..9]).subscribeInner"
        mov	esi, 5
        mov	ecx, offset "wire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..8],3).handler"
        mov	rdi, r15
        mov	rdx, rbx
        call	"data_component_subscription.DataComponentSubscription(@as([*]const Erd, @ptrCast(&codegen_wire_publisher.wire_ram_erds))[0..9]).subscribeInner"
        mov	esi, 6
        mov	ecx, offset "wire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..8],3).handler"
        mov	rdi, r15
        mov	rdx, rbx
        call	"data_component_subscription.DataComponentSubscription(@as([*]const Erd, @ptrCast(&codegen_wire_publisher.wire_ram_erds))[0..9]).subscribeInner"
        add	r14, 176
        mov	rdi, r14
        mov	rsi, rbx
        pop	rbx
        pop	r14
        pop	r15
        jmp	"data_component_subscription.DataComponentSubscription(@as([*]const Erd, @ptrCast(&codegen_wire_publisher.wire_conv_erds))[0..1]).subscribeInner"

wire_wide_init:
        xorps	xmm0, xmm0
        movups	xmmword ptr [rdi + 32], xmm0
        movups	xmmword ptr [rdi + 16], xmm0
        movups	xmmword ptr [rdi], xmm0
        ret

; --- called functions ---

"ram_data_component.RamDataComponent(@as([*]const Erd, @ptrCast(&codegen_wire_publisher.wire_ram_erds))[0..9]).publish":
        mov	r8, rcx
        mov	rcx, rdx
        movzx	eax, si
        mov	rdx, qword ptr [8*rax + __anon_0]
        movzx	esi, byte ptr [rax + __anon_1]
        shl	rdx, 4
        add	rdi, rdx
        add	rdi, 48
        movzx	edx, word ptr [rax + rax + __anon_2]
        jmp	system_data.publishOnChange

"wire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{ .{ ... }, .{ ... } }[0..2],2).publishWire":
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

"wire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{.{ ... }}[0..1],1).publishWire":
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

"wire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..8],3).publishWire":
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

"data_component_subscription.DataComponentSubscription(@as([*]const Erd, @ptrCast(&codegen_wire_publisher.wire_ram_erds))[0..9]).subscribeInner":
        shl	rsi, 4
        add	rdi, rsi
        mov	esi, 1
        jmp	Subscription.subscribe

Subscription.unsubscribe:
        cmp	qword ptr [rdi + 8], offset codegen_wire_publisher.downstreamCb
        je	.LBB302_1
        cmp	qword ptr [rdi + 24], offset codegen_wire_publisher.downstreamCb
        je	.LBB302_3
        cmp	qword ptr [rdi + 40], offset codegen_wire_publisher.downstreamCb
        je	.LBB302_5
        ret
.LBB302_1:
        add	rdi, 8
        mov	qword ptr [rdi], 0
        ret
.LBB302_3:
        add	rdi, 24
        mov	qword ptr [rdi], 0
        ret
.LBB302_5:
        add	rdi, 40
        mov	qword ptr [rdi], 0
        ret

Subscription.subscribe:
        mov	r8, qword ptr [rdi + 8]
        cmp	r8, rcx
        je	.LBB27_8
        xor	eax, eax
        test	r8, r8
        cmove	rax, rdi
        cmp	rsi, 1
        je	.LBB27_6
        mov	r9, qword ptr [rdi + 24]
        cmp	r9, rcx
        je	.LBB27_8
        lea	r10, [rdi + 16]
        xor	eax, eax
        test	r9, r9
        cmove	rax, r10
        test	r8, r8
        cmove	rax, rdi
        cmp	rsi, 2
        je	.LBB27_6
        mov	rsi, qword ptr [rdi + 40]
        cmp	rsi, rcx
        je	.LBB27_8
        add	rdi, 32
        xor	r8d, r8d
        test	rsi, rsi
        cmove	r8, rdi
        test	rax, rax
        cmove	rax, r8
.LBB27_6:
        test	rax, rax
        je	.LBB27_9
        mov	qword ptr [rax], rdx
        mov	qword ptr [rax + 8], rcx
.LBB27_8:
        ret
.LBB27_9:
        push	rax
        mov	edi, offset __anon_3
        mov	esi, 19
        call	debug.defaultPanic

"data_component_subscription.DataComponentSubscription(@as([*]const Erd, @ptrCast(&codegen_wire_publisher.wire_conv_erds))[0..1]).subscribeInner":
        mov	rdx, rsi
        mov	esi, 1
        mov	ecx, offset "wire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..8],3).handler"
        jmp	Subscription.subscribe

system_data.publishOnChange:
        push	r15
        push	r14
        push	r13
        push	r12
        push	rbx
        sub	rsp, 16
        mov	word ptr [rsp + 8], dx
        mov	qword ptr [rsp], rcx
        test	rsi, rsi
        je	.LBB2_5
        mov	rbx, r8
        mov	r14, rsi
        mov	r15, rdi
        shl	r14, 4
        xor	r13d, r13d
        mov	r12, rsp
        jmp	.LBB2_3
.LBB2_2:
        add	r13, 16
        cmp	r14, r13
        je	.LBB2_5
.LBB2_3:
        mov	rax, qword ptr [r15 + r13 + 8]
        test	rax, rax
        je	.LBB2_2
        mov	rdi, qword ptr [r15 + r13]
        mov	rsi, r12
        mov	rdx, rbx
        call	rax
        jmp	.LBB2_2
.LBB2_5:
        add	rsp, 16
        pop	rbx
        pop	r12
        pop	r13
        pop	r14
        pop	r15
        ret

debug.defaultPanic:
        push	rbp
        push	r15
        push	r14
        push	r13
        push	r12
        push	rbx
        sub	rsp, 200
        mov	rax, qword ptr fs:[debug.panic_stage@TPOFF]
        test	rax, rax
        jne	.LBB28_1
        mov	r14, rsi
        mov	r15, rdi
        mov	qword ptr fs:[debug.panic_stage@TPOFF], 1
        lock		add	byte ptr [rip + debug.panicking], 1
        lea	rdi, [rsp + 104]
        call	debug.lockStderr
        mov	r13, qword ptr [rsp + 104]
        movzx	eax, byte ptr [rsp + 112]
        lea	rcx, [r13 + 24]
        mov	qword ptr [rsp + 120], rcx
        and	al, 3
        mov	byte ptr [rsp + 128], al
        cmp	byte ptr fs:[Thread.LinuxThreadImpl.tls_thread_id.1@TPOFF], 1
        mov	qword ptr [rsp + 16], rcx
        jne	.LBB28_5
        mov	r12d, dword ptr fs:[Thread.LinuxThreadImpl.tls_thread_id.0@TPOFF]
        jmp	.LBB28_6
.LBB28_5:
        mov	eax, 186
        #APP
        syscall
        #NO_APP
        mov	r12, rax
        mov	dword ptr fs:[Thread.LinuxThreadImpl.tls_thread_id.0@TPOFF], r12d
        mov	byte ptr fs:[Thread.LinuxThreadImpl.tls_thread_id.1@TPOFF], 1
.LBB28_6:
        xor	ebp, ebp
.LBB28_7:
        lea	rsi, [rbp + __anon_4]
        mov	rbx, rbp
        xor	rbx, 7
        mov	rdi, qword ptr [r13 + 48]
        lea	rax, [rdi + rbx]
        cmp	rax, qword ptr [r13 + 40]
        ja	.LBB28_9
        add	rdi, qword ptr [r13 + 32]
        mov	rdx, rbx
        call	memcpy@PLT
        add	qword ptr [r13 + 48], rbx
        add	rbp, rbx
        cmp	rbp, 7
        jb	.LBB28_7
        jmp	.LBB28_12
.LBB28_9:
        mov	rcx, qword ptr [rsp + 16]
        mov	rax, qword ptr [rcx]
        mov	rax, qword ptr [rax]
        mov	qword ptr [rsp], rsi
        mov	qword ptr [rsp + 8], rbx
        mov	rsi, rcx
        mov	ecx, 1
        mov	r8d, 1
        lea	rdi, [rsp + 31]
        mov	rdx, rsp
        call	rax
        cmp	word ptr [rsp + 39], 0
        jne	.LBB28_58
        mov	rbx, qword ptr [rsp + 31]
        add	rbp, rbx
        cmp	rbp, 7
        jb	.LBB28_7
.LBB28_12:
        mov	edx, r12d
        mov	eax, 65
        cmp	r12d, 100
        jb	.LBB28_13
.LBB28_25:
        imul	rcx, rdx, 1374389535
        shr	rcx, 37
        imul	esi, ecx, 100
        mov	edi, edx
        sub	edi, esi
        movzx	esi, word ptr [rdi + rdi + __anon_5]
        mov	word ptr [rsp + rax + 29], si
        add	rax, -2
        cmp	rdx, 9999
        mov	rdx, rcx
        ja	.LBB28_25
        mov	qword ptr [rsp + 96], r15
        cmp	ecx, 9
        ja	.LBB28_14
.LBB28_27:
        or	cl, 48
        mov	byte ptr [rsp + rax + 30], cl
        add	rax, -1
        mov	r12, rax
        sub	r12, 65
        je	.LBB28_22
        jmp	.LBB28_16
.LBB28_13:
        mov	rcx, rdx
        mov	qword ptr [rsp + 96], r15
        cmp	ecx, 9
        jbe	.LBB28_27
.LBB28_14:
        movzx	ecx, word ptr [rcx + rcx + __anon_5]
        mov	word ptr [rsp + rax + 29], cx
        add	rax, -2
        mov	r12, rax
        sub	r12, 65
        jne	.LBB28_16
.LBB28_22:
        xor	r12d, r12d
        mov	rbp, rsp
        mov	r15, qword ptr [rsp + 96]
.LBB28_23:
        lea	rsi, [r12 + __anon_6]
        mov	ebx, 8
        sub	rbx, r12
        mov	rdi, qword ptr [r13 + 48]
        lea	rax, [rdi + rbx]
        cmp	rax, qword ptr [r13 + 40]
        ja	.LBB28_28
        add	rdi, qword ptr [r13 + 32]
        mov	rdx, rbx
        call	memcpy@PLT
        add	qword ptr [r13 + 48], rbx
        add	r12, rbx
        cmp	r12, 8
        jb	.LBB28_23
        jmp	.LBB28_31
.LBB28_28:
        mov	rcx, qword ptr [rsp + 16]
        mov	rax, qword ptr [rcx]
        mov	rax, qword ptr [rax]
        mov	qword ptr [rsp], rsi
        mov	qword ptr [rsp + 8], rbx
        mov	rsi, rcx
        mov	ecx, 1
        mov	r8d, 1
        lea	rdi, [rsp + 31]
        mov	rdx, rbp
        call	rax
        cmp	word ptr [rsp + 39], 0
        jne	.LBB28_58
        mov	rbx, qword ptr [rsp + 31]
        add	r12, rbx
        cmp	r12, 8
        jb	.LBB28_23
.LBB28_31:
        xor	r12d, r12d
        mov	rbp, rsp
.LBB28_32:
        lea	rsi, [r15 + r12]
        mov	rbx, r14
        sub	rbx, r12
        mov	rdi, qword ptr [r13 + 48]
        lea	rax, [rdi + rbx]
        cmp	rax, qword ptr [r13 + 40]
        ja	.LBB28_43
        add	rdi, qword ptr [r13 + 32]
        mov	rdx, rbx
        call	memcpy@PLT
        add	qword ptr [r13 + 48], rbx
        add	r12, rbx
        cmp	r12, r14
        jb	.LBB28_32
        jmp	.LBB28_46
.LBB28_43:
        mov	rcx, qword ptr [rsp + 16]
        mov	rax, qword ptr [rcx]
        mov	rax, qword ptr [rax]
        mov	qword ptr [rsp], rsi
        mov	qword ptr [rsp + 8], rbx
        mov	rsi, rcx
        mov	ecx, 1
        mov	r8d, 1
        lea	rdi, [rsp + 31]
        mov	rdx, rbp
        call	rax
        cmp	word ptr [rsp + 39], 0
        jne	.LBB28_67
        mov	rbx, qword ptr [rsp + 31]
        add	r12, rbx
        cmp	r12, r14
        jb	.LBB28_32
.LBB28_46:
        lea	r14, [rsp + 31]
        mov	r15, rsp
.LBB28_47:
        mov	rax, qword ptr [r13 + 48]
        cmp	rax, qword ptr [r13 + 40]
        mov	rsi, qword ptr [rsp + 16]
        jb	.LBB28_48
        mov	rax, qword ptr [rsi]
        mov	rax, qword ptr [rax]
        mov	qword ptr [rsp], offset __anon_7
        mov	qword ptr [rsp + 8], 1
        mov	ecx, 1
        mov	r8d, 1
        mov	rdi, r14
        mov	rdx, r15
        call	rax
        cmp	word ptr [rsp + 39], 0
        jne	.LBB28_67
        cmp	qword ptr [rsp + 31], 0
        je	.LBB28_47
        jmp	.LBB28_51
.LBB28_48:
        mov	rcx, qword ptr [r13 + 32]
        mov	byte ptr [rcx + rax], 10
        add	qword ptr [r13 + 48], 1
.LBB28_51:
        mov	rax, qword ptr [rsp + 248]
        mov	qword ptr [rsp + 152], rax
        mov	byte ptr [rsp + 160], 1
        mov	qword ptr [rsp + 168], 0
        mov	byte ptr [rsp + 176], 1
        lea	rdi, [rsp + 152]
        lea	rsi, [rsp + 120]
        call	debug.writeCurrentStackTrace
        movzx	eax, word ptr [rip + Io.Threaded.global_single_threaded_instance+64]
        test	ax, ax
        jne	.LBB28_52
        mov	rax, qword ptr [rip + Io.Threaded.global_single_threaded_instance+24]
        mov	edi, offset Io.Threaded.global_single_threaded_instance+24
        call	qword ptr [rax + 16]
        movzx	eax, word ptr [rip + Io.Threaded.global_single_threaded_instance+64]
.LBB28_52:
        test	ax, ax
        je	.LBB28_55
        movzx	eax, ax
        cmp	eax, 3
        jne	.LBB28_54
        lock		xor	qword ptr [8], 1
.LBB28_54:
        mov	word ptr [rip + Io.Threaded.global_single_threaded_instance+64], 0
.LBB28_55:
        mov	qword ptr [rip + Io.Threaded.global_single_threaded_instance+32], 1
        xorps	xmm0, xmm0
        movups	xmmword ptr [rip + Io.Threaded.global_single_threaded_instance+40], xmm0
        add	qword ptr [rip + Io.Threaded.global_single_threaded_instance+800], -1
        jne	.LBB28_40
        mov	dword ptr [rip + Io.Threaded.global_single_threaded_instance+844], -1
        xor	eax, eax
        xchg	dword ptr [rip + Io.Threaded.global_single_threaded_instance+848], eax
        cmp	eax, 2
        je	.LBB28_57
.LBB28_40:
        lock		sub	byte ptr [rip + debug.panicking], 1
        je	.LBB28_2
        mov	dword ptr [rsp + 31], 0
        lea	rdi, [rsp + 31]
        mov	esi, 128
.LBB28_42:
        mov	eax, 202
        xor	edx, edx
        xor	r10d, r10d
        #APP
        syscall
        #NO_APP
        jmp	.LBB28_42
.LBB28_16:
        neg	r12
        lea	rbp, [rsp + rax]
        add	rbp, 31
        xor	r15d, r15d
.LBB28_17:
        lea	rsi, [r15 + rbp]
        mov	rbx, r12
        sub	rbx, r15
        mov	rdi, qword ptr [r13 + 48]
        lea	rax, [rdi + rbx]
        cmp	rax, qword ptr [r13 + 40]
        ja	.LBB28_19
        add	rdi, qword ptr [r13 + 32]
        mov	rdx, rbx
        call	memcpy@PLT
        add	qword ptr [r13 + 48], rbx
        add	r15, rbx
        cmp	r15, r12
        jb	.LBB28_17
        jmp	.LBB28_22
.LBB28_19:
        mov	rcx, qword ptr [rsp + 16]
        mov	rax, qword ptr [rcx]
        mov	rax, qword ptr [rax]
        mov	qword ptr [rsp + 136], rsi
        mov	qword ptr [rsp + 144], rbx
        mov	rsi, rcx
        mov	ecx, 1
        mov	r8d, 1
        mov	rdi, rsp
        lea	rdx, [rsp + 136]
        call	rax
        cmp	word ptr [rsp + 8], 0
        jne	.LBB28_58
        mov	rbx, qword ptr [rsp]
        add	r15, rbx
        cmp	r15, r12
        jb	.LBB28_17
        jmp	.LBB28_22
.LBB28_58:
        movzx	eax, word ptr [rip + Io.Threaded.global_single_threaded_instance+64]
        test	ax, ax
        jne	.LBB28_59
        mov	rax, qword ptr [rip + Io.Threaded.global_single_threaded_instance+24]
        mov	edi, offset Io.Threaded.global_single_threaded_instance+24
        call	qword ptr [rax + 16]
        movzx	eax, word ptr [rip + Io.Threaded.global_single_threaded_instance+64]
.LBB28_59:
        test	ax, ax
        je	.LBB28_62
        movzx	eax, ax
        cmp	eax, 3
        jne	.LBB28_61
        lock		xor	qword ptr [8], 1
.LBB28_61:
        mov	word ptr [rip + Io.Threaded.global_single_threaded_instance+64], 0
.LBB28_62:
        mov	qword ptr [rip + Io.Threaded.global_single_threaded_instance+32], 1
        xorps	xmm0, xmm0
        movups	xmmword ptr [rip + Io.Threaded.global_single_threaded_instance+40], xmm0
        add	qword ptr [rip + Io.Threaded.global_single_threaded_instance+800], -1
        jne	.LBB28_40
        mov	dword ptr [rip + Io.Threaded.global_single_threaded_instance+844], -1
        xor	eax, eax
        xchg	dword ptr [rip + Io.Threaded.global_single_threaded_instance+848], eax
        cmp	eax, 2
        jne	.LBB28_40
        mov	eax, 202
        mov	edi, offset Io.Threaded.global_single_threaded_instance+848
        mov	esi, 129
        mov	edx, 1
        #APP
        syscall
        #NO_APP
        jmp	.LBB28_40
.LBB28_67:
        movzx	eax, word ptr [rip + Io.Threaded.global_single_threaded_instance+64]
        test	ax, ax
        jne	.LBB28_68
        mov	rax, qword ptr [rip + Io.Threaded.global_single_threaded_instance+24]
        mov	edi, offset Io.Threaded.global_single_threaded_instance+24
        call	qword ptr [rax + 16]
        movzx	eax, word ptr [rip + Io.Threaded.global_single_threaded_instance+64]
.LBB28_68:
        test	ax, ax
        je	.LBB28_71
        movzx	eax, ax
        cmp	eax, 3
        jne	.LBB28_70
        lock		xor	qword ptr [8], 1
.LBB28_70:
        mov	word ptr [rip + Io.Threaded.global_single_threaded_instance+64], 0
.LBB28_71:
        mov	qword ptr [rip + Io.Threaded.global_single_threaded_instance+32], 1
        xorps	xmm0, xmm0
        movups	xmmword ptr [rip + Io.Threaded.global_single_threaded_instance+40], xmm0
        add	qword ptr [rip + Io.Threaded.global_single_threaded_instance+800], -1
        jne	.LBB28_40
        mov	dword ptr [rip + Io.Threaded.global_single_threaded_instance+844], -1
        xor	eax, eax
        xchg	dword ptr [rip + Io.Threaded.global_single_threaded_instance+848], eax
        cmp	eax, 2
        jne	.LBB28_40
        mov	eax, 202
        mov	edi, offset Io.Threaded.global_single_threaded_instance+848
        mov	esi, 129
        mov	edx, 1
        #APP
        syscall
        #NO_APP
        jmp	.LBB28_40
.LBB28_57:
        mov	eax, 202
        mov	edi, offset Io.Threaded.global_single_threaded_instance+848
        mov	esi, 129
        mov	edx, 1
        #APP
        syscall
        #NO_APP
        jmp	.LBB28_40
.LBB28_1:
        cmp	rax, 1
        jne	.LBB28_2
        mov	qword ptr fs:[debug.panic_stage@TPOFF], 2
        lea	rdi, [rsp + 184]
        call	debug.lockStderr
        mov	r13, qword ptr [rsp + 184]
        lea	rbx, [r13 + 24]
        xor	ebp, ebp
        lea	r14, [rsp + 31]
        mov	r15, rsp
.LBB28_35:
        lea	rsi, [rbp + __anon_8]
        mov	r12d, 32
        sub	r12, rbp
        mov	rdi, qword ptr [r13 + 48]
        lea	rax, [rdi + r12]
        cmp	rax, qword ptr [r13 + 40]
        ja	.LBB28_37
        add	rdi, qword ptr [r13 + 32]
        mov	rdx, r12
        call	memcpy@PLT
        add	qword ptr [r13 + 48], r12
        add	rbp, r12
        cmp	rbp, 32
        jb	.LBB28_35
        jmp	.LBB28_2
.LBB28_37:
        mov	rax, qword ptr [rbx]
        mov	rax, qword ptr [rax]
        mov	qword ptr [rsp], rsi
        mov	qword ptr [rsp + 8], r12
        mov	ecx, 1
        mov	r8d, 1
        mov	rdi, r14
        mov	rsi, rbx
        mov	rdx, r15
        call	rax
        cmp	word ptr [rsp + 39], 0
        jne	.LBB28_2
        mov	r12, qword ptr [rsp + 31]
        add	rbp, r12
        cmp	rbp, 32
        jb	.LBB28_35
.LBB28_2:
        call	process.abort
        .text

