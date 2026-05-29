; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal
; Two watched ERDs (u8 no-swap + u32 swap): tiny binary search, conditional swap.
;
wire_pair_handler:
        jmp	".Lwire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{ .{ ... }, .{ ... } }[0..2],2).handler"

; --- called functions ---

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
        ja	.L0
        jmp	.L1
.L2:
        mov	rcx, r8
        mov	r8, rcx
        sub	r8, rdx
        jbe	.L1
.L0:
        shr	r8
        add	r8, rdx
        mov	r9, r8
        shl	r9, 4
        movzx	r10d, word ptr [r9 + ".Lwire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{ .{ ... }, .{ ... } }[0..2],2).descriptors"+8]
        cmp	r10w, ax
        je	.L3
        jae	.L2
        add	r8, 1
        mov	rdx, r8
        mov	r8, rcx
        sub	r8, rdx
        ja	.L0
        jmp	.L1
.L3:
        mov	r15, rdi
        lea	r12, [r9 + ".Lwire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{ .{ ... }, .{ ... } }[0..2],2).descriptors"]
        mov	rsi, qword ptr [rsi]
        movzx	r14d, word ptr [r12 + 12]
        lea	rdi, [rsp + 4]
        mov	rdx, r14
        call	memcpy@PLT
        mov	rax, qword ptr [r12]
        test	rax, rax
        je	.L4
        lea	rdi, [rsp + 4]
        mov	rsi, r14
        call	rax
.L4:
        movzx	esi, word ptr [r12 + 10]
        lea	rdx, [rsp + 4]
        mov	rdi, r15
        mov	rcx, r14
        mov	r8, rbx
        call	".Lwire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{ .{ ... }, .{ ... } }[0..2],2).publishWire"
.L1:
        add	rsp, 8
        pop	rbx
        pop	r12
        pop	r14
        pop	r15
        ret

