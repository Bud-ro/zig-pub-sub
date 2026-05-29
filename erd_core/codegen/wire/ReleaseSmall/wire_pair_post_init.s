; snapshot_comments.zig
; Speed: Optimal | Size: Optimal
;
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

; --- called functions ---

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

