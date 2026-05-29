; snapshot_comments.zig
; Speed: Optimal | Size: Optimal
;
wire_single_post_init:
        mov	rax, rdi
        mov	edx, offset ".Lwire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{.{ ... }}[0..1],1).handler"
        mov	rdi, rsi
        mov	rsi, rax
        jmp	".Lsystem_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents).subscribe__anon_0"

; --- called functions ---

".Lsystem_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents).subscribe__anon_0":
        mov	rcx, rdx
        mov	rdx, rsi
        add	rdi, 48
        xor	esi, esi
        jmp	".Ldata_component_subscription.DataComponentSubscription(@as([*]const Erd, @ptrCast(&codegen_wire_publisher.wire_ram_erds))[0..9]).subscribeInner"

